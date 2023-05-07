local QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory

local cachedPoliceAmount = {}

QBCore.Functions.CreateCallback('possible-atm-robbery:server:getCops', function(source, cb)
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if not Config.UsePoliceName then 
            if v.PlayerData.job.type == Config.PoliceJobType and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        else 
            if v.PlayerData.job.name == Config.PoliceJobName and v.PlayerData.job.onduty then
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
    if Config.InventoryType == "qb-inventory" then
        if Player.Functions.RemoveItem(Config.RequiredItem, 1) then
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.RequiredItem], "remove", 1)
        end
    elseif Config.InventoryType == "ox_inventory" then
        ox_inventory:RemoveItem(source, Config.RequiredItem, 1)
    end
end)

RegisterServerEvent('possible-atm-robbery:giveReward')
AddEventHandler('possible-atm-robbery:giveReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward = math.random(Config.MinReward, Config.MaxReward)
    if Config.InventoryType == "qb-inventory" then
        if Player.Functions.AddItem(Config.DirtyCashType, reward) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.DirtyCashType], "add", reward)
        end
        elseif Config.InventoryType == "ox_inventory" then
            ox_inventory:AddItem(src, Config.DirtyCashType, reward)
        end
end)

