local config = require('shared.config')

local QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory

local cashA = config.MinReward
local cashB = config.MaxReward

local cachedPoliceAmount = {}

QBCore.Functions.CreateCallback('possible-atm-robbery:server:getCops', function(source, cb)
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if not config.UsePoliceName then 
            if v.PlayerData.job.type == config.PoliceJobType and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        else 
            if v.PlayerData.job.name == config.PoliceJobName and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
    end
    cachedPoliceAmount[source] = amount
    cb(amount)
end)

RegisterServerEvent('possible-atm-robbery:removeRequiredItem')
AddEventHandler('possible-atm-robbery:removeRequiredItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if config.InventoryType == "qb-inventory" then
        if Player.Functions.RemoveItem(config.RequiredItem, 1) then
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[config.RequiredItem], "remove", 1)
        end
    elseif config.InventoryType == "ox_inventory" then
        ox_inventory:RemoveItem(source, config.RequiredItem, 1)
    end
end)

RegisterServerEvent('possible-atm-robbery:giveReward')
AddEventHandler('possible-atm-robbery:giveReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward = math.random(cashA, cashB)
	local markedBillsBagsAmount = math.random(3,5) -- Range of marked bills bags for the player to randomly recieve
	local markedBillsBagsWorth = {
		worth = math.random(cashA, cashB)
    }
    if config.InventoryType == "qb-inventory" then
        if config.Cash then
            Player.Functions.AddMoney('cash', reward)
            TriggerClientEvent('QBCore:Notify', src, 'You have received $'..reward..' in cash', 'success')
        else
        Player.Functions.AddItem(config.DirtyCashType, markedBillsBagsAmount, false, markedBillsBagsWorth)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
        end
    elseif config.InventoryType == "ox_inventory" then
        if config.Cash then
            ox_inventory:AddItem(src, 'money', reward)
        else
            ox_inventory:AddItem(src, config.DirtyCashType, reward)
        end
    end
end)

