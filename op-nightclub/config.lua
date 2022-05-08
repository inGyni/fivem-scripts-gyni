Config = {}

Config.CurrentDJ = "dixon"
Config.Banner = "ba_case7_" .. Config.CurrentDJ
Config.Barrier = "ba_barriers_case7"
Config.NightclubLocation = vector3(4.88, 220.14, 107.71)

Config.DJs = {
	[0] = "solomun",
	[1] = "taleofus",
	[2] = "dixon",
	[3] = "madonna",
}

-- Configure the coordinates for each nightclub
Config.Teleports = {
	[0] = {
        [1] = { -- ENTRANCE
            coords = vector3(4.88, 220.14, 107.71),
            drawText = 'Press [~g~E~w~] to enter the ~p~Nightclub~w~'
        },
        [2] = { -- EXIT
            coords = vector3(-1569.39, -3017.21, -74.41),
            drawText = 'Press [~g~E~w~] to leave the ~p~Nightclub~w~'
        },
    },
}

Config.InteriorsProps = {
      "Int01_ba_security_upgrade",
      "Int01_ba_equipment_setup",
      "Int01_ba_Style01﻿",
      "Int01_ba_Style02﻿",
      "Int01_ba_Style03",
      "DJ_03_Lights_02",
	  "Int01_ba_style01_podium",
      "Int01_ba_style02_podium",
      "Int01_ba_style03_podium",
      "Int01_ba_dry_ice",
	  "int01_ba_lights_screen",
      "Int01_ba_Screen",
      "Int01_ba_dj04",
      "Int01_ba_lightgrid_01",
	  "Int01_ba_trad_lights",
      "Int01_ba_clubname_03",
	  "Int01_ba_bar_content",
}