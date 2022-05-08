
local QBCore = exports['qb-core']:GetCoreObject()

local gotTicket = false
local minutes = 0
local seconds = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if gotTicket then
            if hasPlayerRunOutOfTime() then
                QBCore.Functions.Notify("Your play card has expired.")
                gotTicket = false
                SendNUIMessage({
                    type = "off",
                    game = "",
                })
                SetNuiFocus(false, false)
            end
            countTime()
            displayTime()
            if gotTicket == false then
                --exports['casinoUi']:HideCasinoUi('hide')
            end
        end
    end
end)

function hasPlayerRunOutOfTime()
    return (minutes == 0 and seconds <= 1)
end

function countTime()
    seconds = seconds - 1
    if seconds == 0 then
        seconds = 59
        minutes = minutes - 1
    end

    if minutes == -1 then
        minutes = 0
        seconds = 0
    end
end

function displayTime()
    --exports['casinoUi']:DrawCasinoUi('show', "Arcade Card Time</br> "..minutes..":"..seconds)
end

function doesPlayerHaveTicket()
    return gotTicket
end

RegisterNetEvent("arcade:client:openTicketMenu")
AddEventHandler("arcade:client:openTicketMenu", function()
    if gotTicket == false then
        playerBuyTicketMenu()
    else
        returnTicketMenu()
    end
end)

RegisterNetEvent("arcade:client:openArcadeGames")
AddEventHandler("arcade:client:openArcadeGames", function()
    openComputerMenu()
end)

RegisterNetEvent("op-arcade:clientticketResult")
AddEventHandler("op-arcade:clientticketResult", function(ticket)
    seconds = 1
    minutes = Config.TicketPrices[ticket].time
    gotTicket = true
    QBCore.Functions.Notify("Play Time: "..Config.TicketPrices[ticket].time.." minutes", "primary")
end)

RegisterNetEvent('op-arcade:client:buyTicket')
AddEventHandler('op-arcade:client:buyTicket', function(args)
    local args = tonumber(args)
    if args == 1 then 
        TriggerServerEvent("op-arcade:server:buyTicket", 'arcadeblue')
    elseif args == 2 then 
        TriggerServerEvent("op-arcade:server:buyTicket", 'arcadegreen')
    else
        TriggerServerEvent("op-arcade:server:buyTicket", 'arcadegold')
    end
end)

RegisterNetEvent('op-arcade:client:returnTicket')
AddEventHandler('op-arcade:client:returnTicket', function()
    minutes = 0
    seconds = 0 
    gotTicket = false
    QBCore.Functions.Notify("Play card is no longer valid", "primary")
    --exports['casinoUi']:HideCasinoUi('hide') 
end)

RegisterNUICallback('exit', function()
    SendNUIMessage({
        type = "off",
        game = "",
    })
    SetNuiFocus(false, false)
end)

RegisterNetEvent('op-arcade:client:playArcade')
AddEventHandler('op-arcade:client:playArcade', function(args)
    local args = tonumber(args)
    if args == 1 then 
        SendNUIMessage({
            type = "on",
            game = 'https://xogos.robinko.eu/PACMAN/',
            gpu = Config.GPUList[2],
            cpu =  Config.CPUList[1],
            SetNuiFocus(true, true)
        })
        elseif args == 2  then
            SendNUIMessage({
                type = "on",
                game = 'https://xogos.robinko.eu/TETRIS/',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 3 then
            SendNUIMessage({
                type = "on",
                game = 'https://xogos.robinko.eu/PONG/',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 4 then
            SendNUIMessage({
                type = "on",
                game = 'https://lama.robinko.eu/fullscreen.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 5 then
            SendNUIMessage({
                type = "on",
                game = 'https://uno.robinko.eu/fullscreen.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 6 then
            SendNUIMessage({
                type = "on",
                game = 'https://ants.robinko.eu/fullscreen.html',
                gpu = Config.GPUList[2], 
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 7 then
            SendNUIMessage({
                type = "on",
                game = 'https://xogos.robinko.eu/FlappyParrot/',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 8 then
            SendNUIMessage({
                type = "on",
                game = 'https://zoopaloola.robinko.eu/Embed/fullscreen.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 9 then  
            SendNUIMessage({
                type = "on",
                game = 'https://gulper.io',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        else  
            SendNUIMessage({
                type = "on",
                game = 'https://www.google.com/logos/fnbx/solitaire/standalone.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
    end
end) 


function playerBuyTicketMenu()
    exports['qb-menu']:openMenu({
        {
            header = "Arcade Shop",
            isMenuHeader = true,
        },
        {
            header = "Blue Play Card $50 for 15 minutes",
            txt = "Purchase",
			params = {
                event = "op-arcade:client:buyTicket",
                args = '1'
            }
        },
        {
            header = "Green Play Card $100 for 30 minutes",
            txt = "Purchase",
			params = {
                event = "op-arcade:client:buyTicket",
                args = '2'
            }
        },
        {
            header = "Gold Play Card $150 for 45 minutes",
            txt = "Purchase",
			params = {
                event = "op-arcade:client:buyTicket",
                args = '3'
            }
        },
        {
            header = "< Exit",
			txt = "",
			params = {
                event = ""
            }
        },
    })
end

function returnTicketMenu()
    exports['qb-menu']:openMenu({
        {
            header = "Arcade Employee",
            isMenuHeader = true,
        },
        {
            header = "Stop Using Arcade",
			txt = "End Play Card",
			params = {
                event = "op-arcade:client:returnTicket",
            }
        },
        {
            header = "Cancel",
			txt = "",
			params = {
                event = ""
            }
        },
    })
end


function openComputerMenu()
    if not gotTicket then
        QBCore.Functions.Notify("You don't have a valid play card", "error")
        return
    end
    exports['qb-menu']:openMenu({
        {
            header = "Arcade Game Selection",
            isMenuHeader = true,
        },
        {
            header = "Play Pacman",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '1'
            }
        },
        {
            header = "Play Tetris",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '2'
            }
        },
        {
            header = "Play PingPong",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '3'
            }
        },
        {
            header = "Play Slide a Lama",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '4'
            }
        },
        {
            header = "Play Uno",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '5'
            }
        },
        {
            header = "Play Ants",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '6'
            }
        },
        {
            header = "Play FlappyParrot",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '7'
            }
        },
        {
            header = "Play Zoopaloola",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '8'
            }
        },
        {
            header = "Play Gulper.io (NEW)",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '9'
            }
        },
        {
            header = "Play Solitaire (NEW)",
			txt = "",
			params = {
                event = "op-arcade:client:playArcade",
                args = '10'
            }
        },
        {
            header = "Cancel",
			txt = "",
			params = {
                event = ""
            }
        },
    })
end

Citizen.CreateThread(function()
    for _,v in pairs(Config.ArcadeInfo) do
        QBCore.Functions.LoadModel(v.model)
        ArcadePed =  CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z, v.coords.w, true, true)
        SetEntityHeading(ArcadePed, v.coords.w)
        FreezeEntityPosition(ArcadePed, true)
        SetEntityInvincible(ArcadePed, true)
        SetBlockingOfNonTemporaryEvents(ArcadePed, true)
        TaskStartScenarioInPlace(ArcadePed, "WORLD_HUMAN_STAND_MOBILE_UPRIGHT", 0, true) 
		exports['qb-target']:AddTargetModel(v.model, {
			options = {
				{
					event = "arcade:client:openTicketMenu",
					icon = "fa-solid fa-gamepad",
					label = "Open Arcade Shop",
				},
			},
			distance = 3.0
		})

        local blip = AddBlipForCoord(v.coords)
        SetBlipSprite(blip, 606)
        SetBlipColour(blip, 58)
        SetBlipScale(blip, 0.65)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Arcade")
        EndTextCommandSetBlipName(blip)


    end
	
	
	exports['qb-target']:AddTargetModel(Config.ArcadeGames, {
    options = {
        { 
            event = "arcade:client:openArcadeGames",
            icon = "fa-solid fa-gamepad",
            label = "Play Arcade",
        },
    },
    distance = 3.0
})
end)



