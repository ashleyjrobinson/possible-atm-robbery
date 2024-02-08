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
    PossibleGangLevel = true, -- Integrates my paid gang level script - https://possible-scripts.tebex.io/package/6036883 set false if no likey
    Cash = true,
    CashItem = 'cash',
    DirtyCashType = 'markedbills', -- If using qb-inventory and cahs = false
    MinReward = 500, 
    MaxReward = 2000,
    NotifPosition = 'top'
}