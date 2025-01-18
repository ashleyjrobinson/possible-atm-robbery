return {
    Debug = false,
    Framework = "qb",
    Police = {
        jobs = {
            "police"
        }
    },
    MinimumPolice = 1,
    Dispatch = 'ps-dispatch', -- If using qb-dispatch otherwise add your export in client policeCall function
    RequiredItem = 'atmhacker',
    InventoryType = 'ox_inventory',
    LabelIcon = 'fa-solid fa-user-ninja',
    ProgressDuration = 7500,
    Emotes = 'rpemotes', -- If using rpemotes otherwise anything else for scully_emotemenu
    PossibleTerritories = true, -- Integrates my paid territrory script - https://possible-scripts.tebex.io/package/6045013 set false if no likey
    TerritoriesInfluence = 10, -- Only relevant if PossibleTerritories is true
    TerritoriesRewardItem = 'cash', -- Only relevant if PossibleTerritories is true
    TerritoriesRewardAmount = 30, -- Only relevant if PossibleTerritories is true
    PossibleGangLevel = true,  -- Integrates my paid gang levels script - https://possible-scripts.tebex.io/package/6036883 set false if no likey
    GangXPReward = 5, -- Only relevant if PossibleGangLevels is true
    Cash = true,
    CashItem = 'cash',
    DirtyCashType = 'markedbills', -- If using qb-inventory and cahs = false
    MinReward = 500, 
    MaxReward = 2000,
    NotifPosition = 'top'
}