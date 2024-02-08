lib.locale()
local config = require('shared.config')
local policeCount = nil 

local function policeCall()
    if config.Dispatch == "ps-dispatch" then
     exports['ps-dispatch']:ATMHacking()
    else
    -- Add your custom export here
    end
end

local modelsATM = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

local optionATM = {
    {
        name = 'HackATM',
        icon = config.LabelIcon,
        label = locale('target_label'),
        items = config.RequiredItem,
        distance = 2.5,
        onSelect = function()
            TriggerEvent('possible-atm-robbery:client:startHack')
        end
    }
}

exports.ox_target:addModel(modelsATM, optionATM)

local function onHackDone(success)
    ClearPedTasks(PlayerPedId())
    if success then
        if config.Emotes == 'rpemotes' then
            exports["rpemotes"]:EmoteCancel(forceCancel)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        TriggerEvent('mhacking:hide')
        if lib.progressBar({
            duration = config.ProgressDuration,
            label = locale('looting_progress_label'),
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
                title = locale('looting_success_title'),
                description = locale('looting_success_description'),
                type = 'success',
                position = config.NotifPosition,
                icon = config.NotifIcon
            })
            TriggerEvent('possible-atm-robbery:client:success')
        else
            lib.cancelProgress()
            lib.notify({
                title = locale('looting_signal_lost_title'),
                description = locale('looting_signal_lost_description'),
                type = 'error',
                position = config.NotifPosition,
                icon = config.NotifIcon
            })
        end
    else
        lib.notify({
            title = locale('looting_failed_title'),
            description = locale('looting_failed_description'),
            type = 'error',
            position = config.NotifPosition,
            icon = config.NotifIcon
        })
        TriggerEvent("mhacking:hide")
        if config.Emotes == 'rpemotes' then
            exports["rpemotes"]:EmoteCancel(forceCancel)
        else
            exports.scully_emotemenu:cancelEmote()
        end
    end
end

RegisterNetEvent('possible-atm-robbery:client:receivePoliceCount', function(count)
    policeCount = count
    if config.Debug then
        print('Police count: ' .. policeCount)
    end
end)

RegisterNetEvent('possible-atm-robbery:client:startHack', function()
    TriggerServerEvent('possible-atm-robbery:server:requestPoliceCount')
    Wait(500)
    if policeCount >= config.MinimumPolice then
            if config.Emotes == 'rpemotes' then
                exports["rpemotes"]:EmoteCommandStart("phone")
            else
                exports.scully_emotemenu:playEmoteByCommand('phone')
            end
            policeCall()
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), onHackDone)
        else
            lib.notify({
                title = locale('not_enough_police_title'),
                description = locale('not_enough_police_description'),
                type = 'error',
                position = config.NotifPosition,
                icon = config.NotifIcon
            })
     end
end)

RegisterNetEvent('possible-atm-robbery:client:success', function()
    TriggerServerEvent('possible-atm-robbery:server:giveReward', source)
end)

