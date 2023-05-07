# Possible ATM Robberies


[Preview](https://www.youtube.com/watch?v=f_rKE9o01IQ)
[Discord/ Support](https://discord.gg/Gnb2S7uAdG)


## Item:

qb-inventory/ lj-inventory -

create an item named phone_hacker in your qb-core/shared/items.lua

```
	['atmhacker'] 			 = {['name'] = 'atmhacker', 			  	['label'] = 'ATM Hacker', 			['weight'] = 750, 		['type'] = 'item', 		['image'] = 'atmhacker.png', 	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Use for malicious activities..'},
```

## ox_inventory -

create an item named phone_hacker in your qb-core/shared/items.lua

```
	['atmhacker'] = {
		label = 'ATM Hacker',
		weight = 750,
        description = 'Use for malicious activities..',
	},
```

## Image:

I've placed the inventory image within the assets folder, take this imagae and put it in your qb-inventory or ox-inventory imagery folder. Then delete the assets folder within here.

## Dispatch:

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
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "atmhacking", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-35",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = 'ATM Hacking Reported', -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end
exports('ATMHacking', ATMHacking)
```

## Support:

Join my Discord for support and roles.

https://discord.gg/5VU8MA7Tkz