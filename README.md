# Possible ATM Robberies


[Preview](https://www.youtube.com/watch?v=f_rKE9o01IQ) //
[Discord/ Support](https://discord.gg/Gnb2S7uAdG)


## Item:

qb-inventory/ lj-inventory -

create an item named phone_hacker in your qb-core/shared/items.lua

```
	['atmhacker'] 			 = {['name'] = 'atmhacker', 			  	['label'] = 'ATM Hacker', 			['weight'] = 750, 		['type'] = 'item', 		['image'] = 'atmhacker.png', 	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Use for malicious activities..'},
```

## ox_inventory -

create an item named phone_hacker in your ox_inventory/data/items.lua

```
	['atmhacker'] = {
		label = 'ATM Hacker',
		weight = 750,
        description = 'Use for malicious activities..',
	},
```

## Image:

I've placed the inventory image within the assets folder, take this imagae and put it in your qb-inventory or ox-inventory imagery folder. Then delete the assets folder within here.

## Dispatch (or easily add your own):

Project Sloth Dispatch - https://github.com/Project-Sloth/ps-dispatch

Copy & Paste this into ps-dispatch/server/sv_dispatchcodes.lua

```
["atmhacking"] =  {displayCode = '10-90', description = "Potential ATM hacking activity reported..", radius = 0, recipientList = {'police'}, blipSprite = 772, blipColour = 59, blipScale = 1.5, blipLength = 2, sound = "robberysound", offset = "false", blipflash = "false"},
```

Copy & Paste this into ps-dispatch/client/cl_extraalerts.lua

```
---------------------------
-- Possible ATM Hacking --
---------------------------

local function ATMHacking()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('atmhacking'),
        codeName = 'atmhacking',
        code = '10-90',
        icon = 'fas fa-phone',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('ATMHacking', ATMHacking)

```

## Compatibility:
- QBCore
- QBOX
- ESX

## Dependencies:
- ox_lib
- ox_target
- ox_inventory or qb-inventory
- rpemotes or scully_emotemenu
- mHacking

## Buy Me a Coffee:

If you enjoy my work feel free to buy me a coffee :)

https://www.buymeacoffee.com/possible

## Support:

Join my Discord for support and roles.

https://discord.gg/5VU8MA7Tkz