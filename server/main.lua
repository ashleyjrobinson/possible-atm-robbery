local config = require('shared.config')
local ox_inventory = exports.ox_inventory

local cashA = config.MinReward
local cashB = config.MaxReward

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


RegisterServerEvent('possible-atm-robbery:server:requestPoliceCount', function()
    local policeCount = PoliceCount()  -- Call the function to get the police count
    TriggerClientEvent('possible-atm-robbery:client:receivePoliceCount', source, policeCount)  -- Send police count to the client
end)


RegisterServerEvent('possible-atm-robbery:server:giveReward', function()
    print('triggering give reward')
    local src = source
    local reward = math.random(cashA, cashB)
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
