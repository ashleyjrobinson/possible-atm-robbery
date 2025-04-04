local config = require('shared.config')
local ox_inventory = exports.ox_inventory

local cashA = config.MinReward
local cashB = config.MaxReward
local ATMCooldowns = {}

if config.Framework == "qb" then
    QBCore = exports["qb-core"]:GetCoreObject()
elseif config.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
end

PoliceCount = function()
    local jobCount = 0
    if config.Framework == "qb" then
        for _, players in pairs(QBCore.Functions.GetPlayers()) do
            local player = QBCore.Functions.GetPlayer(players)
            local job = player.PlayerData.job
            for _, jobs in pairs(config.Police.jobs) do
                local jobNames = jobs
                print(jobNames)
                if job.name == jobNames then
                    jobCount = jobCount + 1
                end
            end
        end
    elseif config.Framework == 'esx' then
            for _, player in pairs(ESX.GetExtendedPlayers()) do
                local job = player.getJob()
                for _, jobs in pairs(config.Police.jobs) do
                    local jobNames = jobs
                    if job.name == jobNames then
                        jobCount = jobCount + 1
                    end
                end
            end
        end
    return jobCount
end

local function isATMOnCooldown(atmData)
    
    local atmKey = atmData.uniqueKey
    
    if config.Debug then
        print("Checking cooldown for ATM: " .. atmKey)
    end
    
    if ATMCooldowns[atmKey] then
        local timeRemaining = ATMCooldowns[atmKey] - os.time()
        if timeRemaining > 0 then
            if config.Debug then
                print("ATM on cooldown. Time remaining: " .. timeRemaining .. " seconds")
            end
            return true, timeRemaining
        else
            if config.Debug then
                print("ATM cooldown expired, removing from tracking")
            end
            ATMCooldowns[atmKey] = nil
            return false, 0
        end
    end
    
    if config.Debug then
        print("ATM not on cooldown")
    end
    return false, 0
end

local function setATMOnCooldown(atmData)
    if not atmData or not atmData.uniqueKey then 
        if config.Debug then
            print("Missing uniqueKey in atmData")
        end
        return 
    end
    
    local atmKey = atmData.uniqueKey
    
    ATMCooldowns[atmKey] = os.time() + config.ATMCooldown
    
    if config.Debug then
        print("Set cooldown for ATM: " .. atmKey .. " for " .. config.ATMCooldown .. " seconds")
        print("Current ATM cooldowns: ")
        for k, v in pairs(ATMCooldowns) do
            local remaining = v - os.time()
            print("  - ATM: " .. k .. ", Time remaining: " .. remaining .. " seconds")
        end
    end
end

RegisterServerEvent('possible-atm-robbery:server:requestPoliceCount', function()
    local policeCount = PoliceCount()  -- Call the function to get the police count
    TriggerClientEvent('possible-atm-robbery:client:receivePoliceCount', source, policeCount)  -- Send police count to the client
end)

RegisterServerEvent('possible-atm-robbery:server:checkATMCooldown', function(atmData)
    local src = source
    local onCooldown, timeRemaining = isATMOnCooldown(atmData)
    
    if onCooldown then
        local minutes = math.floor(timeRemaining / 60)
        local seconds = timeRemaining % 60
        local cooldownMessage = string.format("This ATM was recently hacked. Available again in %d minutes and %d seconds", minutes, seconds)
        TriggerClientEvent('possible-atm-robbery:client:atmCooldownResponse', src, true, cooldownMessage)
    else
        TriggerClientEvent('possible-atm-robbery:client:atmCooldownResponse', src, false)
    end
end)

RegisterServerEvent('possible-atm-robbery:server:giveReward', function(atmData)
    local src = source
    local reward = math.random(cashA, cashB)
    
    setATMOnCooldown(atmData)
    
    if config.InventoryType == "qb-inventory" then    
    local Player = QBCore.Functions.GetPlayer(src)
	local markedBillsBagsAmount = math.random(3,5) -- Range of marked bills bags for the player to randomly recieve
	local markedBillsBagsWorth = {
		worth = math.random(cashA, cashB)
    }
    if Player.Functions.RemoveItem(config.RequiredItem, 1) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[config.RequiredItem], "remove", 1)
    end
    if config.Cash then
        Player.Functions.AddMoney('cash', reward)
        TriggerClientEvent('QBCore:Notify', src, 'You have received $'..reward..' in cash', 'success')
    else
        Player.Functions.AddItem(config.DirtyCashType, markedBillsBagsAmount, false, markedBillsBagsWorth)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
    end
    elseif config.InventoryType == "ox_inventory" then
        ox_inventory:RemoveItem(src, config.RequiredItem, 1)
        ox_inventory:AddItem(src, config.CashItem, reward)
    end
    
    if config.PossibleTerritories then
        exports['possible-territories']:AddItemToStash(src, config.TerritoriesRewardItem, config.TerritoriesRewardAmount)
        exports['possible-territories']:UpdateInfluenceForGangInTerritory(src, config.TerritoriesInfluence)
    end

    if config.PossibleGangLevel and config.Framework == "qb" then
        TriggerEvent('possible-atm-robbery:server:rewardGangXP')
    elseif config.PossibleGangLevel and config.Framework == "esx" then
        TriggerEvent('possible-atm-robbery:server:rewardGangXP')
    end
end)

RegisterServerEvent('possible-atm-robbery:server:removeItem', function()
    local src = source
    if config.InventoryType == "qb-inventory" then
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(config.RequiredItem, 1) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[config.RequiredItem], "remove", 1)
    end
    elseif config.InventoryType == "ox_inventory" then
        ox_inventory:RemoveItem(src, config.RequiredItem, 1)
    end
end)

RegisterServerEvent('possible-atm-robbery:server:rewardGangXP', function()
    local src = source
    if config.Framework == "qb" then
        local Player = QBCore.Functions.GetPlayer(src)
        local gangName = Player.PlayerData.gang.name
        exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, config.GangXPReward)
    elseif config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end
        local gangName = xPlayer.job.name
        exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, config.GangXPReward)
    end
end) 
