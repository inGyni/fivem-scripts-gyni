Config = {}

Config.CraftingDistance = 2.5

Config.CraftingTables = {
    {
        type = "weapons",
        tables = {
            [1] = vector3(1198.19, -3114.11, 5.54),
        },
        text = "Press [~g~E~w~] to Open Weapons Crafting",
        title = "Weapons Crafting",
        blacklistedJobs = {
            "police",
            "ambulance",
            "mechanic",
            "cardealer",
        },
    },
    {
        type = "tools",
        tables = {
            [1] = vector3(1208.73, -3114.2, 5.55),
        },
        text = "Press [~g~E~w~] to Open Tools Crafting",
        title = "Tools Crafting",        
        blacklistedJobs = { "" },
    },
}

Config.Craftables = {
    [1] = {
        item = "weapon_assaultrifle",
        name = "Assault Rifle",
        amount = 1,
        requirements = {
            [1] = { item = "aluminum", amount = 145, label = "Aluminum" },
            [2] = { item = "iron", amount = 105, label = "Iron" },
            [3] = { item = "steel", amount = 205, label = "Steel" },
        },
        time = 15000,
        title = "Craft an Assault Rifle",
        info = "crafting_weapon_assaultrifle",
        type = "weapons",
    },
    [2] = {
        item = "weapon_carbinerifle",
        name = "Carbine Rifle",
        amount = 1,
        requirements = {
            [1] = { item = "aluminum", amount = 165, label = "Aluminum" },
            [2] = { item = "iron", amount = 125, label = "Iron" },
            [3] = { item = "steel", amount = 225, label = "Steel" },
        },
        time = 15000,
        title = "Craft a Carbine Rifle",
        info = "crafting_weapon_carbinerifle",
        type = "weapons",
    },
    [3] = {
        item = "advancedrepairkit",
        name = "Advanced Repair Kit",
        amount = 1,
        requirements = {
            [1] = { item = "aluminum", amount = 30, label = "Aluminum" },
            [2] = { item = "iron", amount = 40, label = "Iron" },
            [3] = { item = "steel", amount = 40, label = "Steel" },
        },
        time = 10000,
        title = "Craft an Advanced Repair Kit",
        info = "crafting_advancedrepairkit",
        type = "tools",
    },

}