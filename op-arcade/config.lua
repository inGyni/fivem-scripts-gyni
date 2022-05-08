Config = {}


Config.TicketPrices = {
    ["arcadeblue"] = {
        name = "Arcade Blue",
        price = 50,
        time = 15, -- in minutes
    },
    ["arcadegreen"] = {
        name = "Arcade Green",
        price = 100,
        time = 30, -- in minutes
    },
    ["arcadegold"] = {
        name = "Arcade Gold",
        price = 150,
        time = 45, -- in minutes
    },
}

Config.ArcadeInfo = {
	[0] = { coords = vector4(-1293.08, -301.33, 35.05, 285.45), model = "cs_lifeinvad_01" },
}

Config.ArcadeGames = {
    `ch_prop_arcade_degenatron_01a`,
    `ch_prop_arcade_monkey_01a`,
    `ch_prop_arcade_penetrator_01a`,
    `ch_prop_arcade_space_01a`,
    `ch_prop_arcade_invade_01a`,
    `ch_prop_arcade_wizard_01a`,
    `ch_prop_arcade_claw_01a`,
    `ch_prop_arcade_street_01a`,
    `ch_prop_arcade_street_01b`,
    `ch_prop_arcade_street_01c`,
    `ch_prop_arcade_street_01d`,
    `ch_prop_arcade_street_02b`,
}

-- do not change unless you know what you're doing
Config.GPUList = {
    [1] = "ETX2080",
    [2] = "ETX1050",
    [3] = "ETX660", 
}

-- do not change unless you know what you're doing
Config.CPUList = {
    [1] = "U9_9900",
    [2] = "U7_8700",
    [3] = "U3_6300",
    [4] = "BENTIUM",
}


-- game list for retro machine
Config.RetroMachine = {
    {
        name = "Pacman",
        link = "https://www.google.com/logos/2010/pacman10-i.html",
    },
    {
        name = "Tetris",
        link = "https://tetris.com/play-tetris",
    },
    {
        name = "Ping Pong",
        link = "http://xogos.robinko.eu/PONG/",
    },
    {
        name = "DOOM",
        link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/Doom.zip", "./DOOM.EXE"), --Unused
    },
    {
        name = "Duke Nukem 3D",
        link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/duke3d.zip", "./DUKE3D.EXE"), --Unused
    },
    {
        name = "Wolfenstein 3D",
        link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/Wolfenstein3D.zip", "./WOLF3D.EXE"), --Unused
    },
}

-- game list for gaming machine
Config.GamingMachine = {
    {
        name = "Slide a Lama",
        link = "https://lama.robinko.eu/fullscreen.html",
    },
    {
        name = "Uno",
        link = "http://uno.robinko.eu/fullscreen.html",
    },
    {
        name = "Ants",
        link = "http://ants.robinko.eu/fullscreen.html",
    },
    {
        name = "FlappyParrot",
        link = "http://xogos.robinko.eu/FlappyParrot/",
    },
    {
        name = "Zoopaloola",
        link = "http://zoopaloola.robinko.eu/Embed/fullscreen.html"
    }
}

-- game list for super computer
Config.SuperMachine = {}

for i = 1, #Config.RetroMachine do
    table.insert(Config.SuperMachine, Config.RetroMachine[i])
end

for i = 1, #Config.GamingMachine do
    table.insert(Config.SuperMachine, Config.GamingMachine[i])
end

