local QBCore = exports['qb-core']:GetCoreObject()
local copsCalled = false
local CurrentCops = 0
local PlayerJob = {}
local onDuty = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    onDuty = true
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

local function PoliceCall()
     exports['ps-dispatch']:ATMHacking()
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
      RequestAnimDict(dict)
      Wait(10)
    end
  end

  
function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end
    
local PlayerHasProp = false
local PlayerProps = {}

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(Player))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(GetHashKey(prop1), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function AnimMode()
    Animation = true
    local Player = PlayerPedId()
    local AnimDict = "amb@code_human_wander_texting_fat@male@base"
    local Anim = "static"
    LoadAnim(AnimDict)
    local Prop = 'ch_prop_ch_phone_ing_01a'
    local PropBone = 28422
    AddPropToPlayer(Prop, PropBone, 0.0, -0.02, 0.0, 0.0, 0.0, 0.0)
    TaskPlayAnim(GetPlayerPed(-1), AnimDict, Anim, 2.0, 8.0, -1, 53, 0, false, false, false)
end

function DestroyAllProps()
    for _, v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
end

local modelsATM = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

local optionATM = {
    {
        name = 'possible-atm:hackATM',
        event = 'possible-atm:startHack',
        icon = 'fa-solid fa-user-ninja',
        label = 'Hack ATM',
        items = Config.RequiredItem,
        distance = 2.5,
        onSelect = function()
            TriggerEvent('possible-atm-robbery:startHack')
        end
    }
}

local qbTargetOptionATM = {
    {
        name = 'possible-atm:hackATM',
        event = 'possible-atm:startHack',
        icon = 'fa-solid fa-user-ninja',
        label = 'Hack ATM',
        item = Config.RequiredItem,
        action = function()
            TriggerEvent('possible-atm-robbery:startHack')
        end       
    }
}

local function InitializeTargetSystem()
    if Config.TargetType == "ox_target" then
        exports.ox_target:addModel(modelsATM, optionATM)
    elseif Config.TargetType == "qb-target" then
        exports['qb-target']:AddTargetModel(modelsATM, {
            options = qbTargetOptionATM,
            distance = 2.5
        })
    end
end

InitializeTargetSystem()

local function OnHackDone(success)
    ClearPedTasks(PlayerPedId())
    if success then
        DestroyAllProps()
        TriggerEvent('mhacking:hide')
        if Config.OxLib then
        if lib.progressBar({
            duration = 7500,
            label = 'Looting ATM Machine',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'oddjobs@shop_robbery@rob_till',
                clip = 'loop', 
                lockX = true,
                lockY = true,
                lockZ = true,
            },
        }) then
            lib.notify({
                title = 'Success',
                description = 'You successfully hacked the ATM and grabbed the loot!',
                type = 'success',
                position = 'top',
            })
            TriggerEvent('possible-atm-robbery:success')
        else
            lib.cancelProgress()
            lib.notify({
                title = 'Signal Lost',
                description = 'ATM Signal lost? Try again!',
                type = 'error'
            })
        end
        else
            QBCore.Functions.Progressbar("lootATM", 'Looting ATM Machine', 7500, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = 'oddjobs@shop_robbery@rob_till',
                anim = 'loop',
                flags = 1,
            }, {}, {}, function() -- Done
                TriggerEvent('possible-atm-robbery:success')
                ClearPedTasks(PlayerPedId())
            end, function() -- Cancel
                ClearPedTasks(PlayerPedId())
                QBCore.Functions.Notify('ATM Signal lost? Try again!', 'error', 1500)
            end)
    end
    else
        if Config.OxLib then
        lib.notify({
            title = 'Failed',
            description = 'Failed to hack ATM, signal lost!',
            type = 'error'
        })
        else
        QBCore.Functions.Notify('Failed to hack ATM, signal lost!', 'error', 1500)
        end
        TriggerEvent("mhacking:hide")
        DestroyAllProps()
    end
end


RegisterNetEvent('possible-atm-robbery:startHack')
AddEventHandler('possible-atm-robbery:startHack', function()
    QBCore.Functions.TriggerCallback('possible-atm-robbery:server:getCops', function(cops)
        if cops >= Config.MinimumPolice then
            AnimMode()
            PoliceCall()
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)
        else
            if Config.OxLib then
                lib.notify({
                    title = 'Not right now.',
                    description = 'Not enough police online!',
                    type = 'error'
                })
            else
                QBCore.Functions.Notify('Not enough police online!', 'error', 1500)
            end
        end
    end)
end)

RegisterNetEvent('possible-atm-robbery:success')
AddEventHandler('possible-atm-robbery:success', function()
    TriggerServerEvent('possible-atm-robbery:removeRequiredItem')
    TriggerServerEvent('possible-atm-robbery:giveReward')
end)

