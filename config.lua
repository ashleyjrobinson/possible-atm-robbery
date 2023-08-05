Config = {}

Config.UsePoliceName = false      -- If this is set to "false", server will check for jobname: "police", otherwise it will check for job type for newer qb-core builds
Config.PoliceJobType = "leo"      -- Job type used by your server - if "Config.UsePoliceName = false"
Config.PoliceJobName = "police"   -- Police role in your server - if "Config.UsePoliceName = true"
Config.MinimumPolice = 0         -- Minimum amount of police required to start a robbery

Config.RequiredItem = 'atmhacker'

Config.InventoryType = 'ox_inventory' -- 'qb-inventory' or 'ox_inventory'
Config.TargetType = 'ox_target'       -- 'ox_target' or 'qb-target'

Config.OxLib = true -- set to false if you don't have ox_lib or want to utilise ox_lib


Config.Cash = true -- set to true if you don't want to give cash
Config.DirtyCashType = 'markedbills'  -- 'markedbills' or your dirty cash item

Config.MinReward = 500 -- Minimum reward for hacking a phone
Config.MaxReward = 2000 -- Maximum reward for hacking a phone