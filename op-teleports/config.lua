Config = Config or {}

--[[

TEMPLATE: 

[0] = {
    [1] = {
        coords = vector4(0, 0, 0, 0),
        ["AllowVehicle"] = false,
        drawText = '[E] Take the elevator up'
    },
    [2] = {
        coords = vector4(0, 0, 0, 0),
        ["AllowVehicle"] = false,
        drawText = '[E] Take the Elevator down'
    },
},

]]--

Config.Teleports = {
    [1] = { -- PILLBOX HOSPITAL
        [1] = {
            coords = vector4(340.15, -584.78, 28.8, 270.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the elevator up'
        },
        [2] = {
            coords = vector4(332.29, -595.74, 43.28, 270.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator down'
        },
    },
    [2] = { -- PILLBOX HOSPITAL
        [1] = {
            coords = vector4(341.54, -580.99, 28.8, 270.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the elevator up'
        },
        [2] = {
            coords = vector4(330.32, -601.2, 43.28, 270.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator down'
        },
    },
    [3] = { -- PILLBOX HOSPITAL
        [1] = {
            coords = vector4(344.31, -586.17, 28.8, 70.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the elevator up'
        },
        [2] = {
            coords = vector4(332.29, -595.74, 43.28, 270.0),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator down'
        },
    },
    [4] = { -- PILLBOX HOSPITAL
        [1] = {
            coords = vector4(345.61, -582.56, 28.8, 70.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the elevator up'
        },
        [2] = {
            coords = vector4(330.32, -601.2, 43.28, 270.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator down'
        },
    },
    [5] = { -- PILLBOX HOSPITAL
        [1] = {
            coords = vector4(327.07, -603.8, 43.28, 160.00),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator up to the roof'
        },
        [2] = {
            coords = vector4(338.6, -583.79, 74.16, 70.0),
            color = vector4(0, 150, 0, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator down'
        },
    },
    [6] = { -- CASINO
        [1] = {
            coords = vector4(942.85, 49.0, 80.29, 50.0),
            color = vector4(0, 200, 250, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator up to the roof'
        },
        [2] = {
            coords = vector4(965.05, 58.52, 112.55, 55.47),
            color = vector4(0, 200, 250, 255),
            markerRange = 5.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to take the Elevator down'
        },
    },
    [7] = { -- MONEYWASHING
        [1] = {
            coords = vector4(636.69, 2785.64, 42.01, 202.95),
            color = vector4(0, 120, 0, 255),
            markerRange = 15.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to enter the money laundry'
        },
        [2] = {
            coords = vector4(1138.04, -3198.78, -39.67, 357.82),
            color = vector4(0, 120, 0, 255),
            markerRange = 15.0,
            teleportRange = 1.0,
            drawText = 'Press [~g~E~w~] to leave the money laundry'
        },
    },
}