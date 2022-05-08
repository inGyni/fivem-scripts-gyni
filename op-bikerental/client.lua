local QBCore = exports['qb-core']:GetCoreObject()
local havebike = false

Citizen.CreateThread(function()
	DoScreenFadeIn(2000)
	for k, v in pairs(Config.Locations) do
		local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
		SetBlipSprite(blip, v.id)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.45)
		SetBlipColour(blip, v.colour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.title)
		EndTextCommandSetBlipName(blip)
	end
end)

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent("op-bikerental:client:SpawnBike", function(data)
	if QBCore.Functions.GetPlayerData().money['cash'] > data.price then
		DoScreenFadeOut(1000)
		Citizen.Wait(1000)
		QBCore.Functions.SpawnVehicle(data.bike, function(veh)
			SetVehicleNumberPlateText(veh, "RENT " .. tostring(math.random(100, 999)))
			exports['LegacyFuel']:SetFuel(veh, 100.0)
			TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
			TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
			SetVehicleEngineOn(veh, true, true)
		end, GetEntityCoords(PlayerPedId(), false), true)
		TriggerServerEvent("op-bikerental:server:rentBike", data.price)
		QBCore.Functions.Notify("You've paid $" .. data.price .. " to rent a bike a bike, enjoy!", "success", 3000)
		havebike = true
		DoScreenFadeIn(2000)
    else
        QBCore.Functions.Notify("You don't have enough cash!", 'error', 2000)
    end
	
end)

function OpenBikesMenu()
    local bikeMenu = {
        {
            header = "Bike Rental",
            isMenuHeader = true
        }
    }
    for k, data in pairs(Config.Bikes) do
        bikeMenu[#bikeMenu+1] = {
            header = data.label,
            txt = data.desc .. tostring(data.price),
            params = {
                event = "op-bikerental:client:SpawnBike",
                args = {
                    bike = data.id,
					price = data.price
                }
            }
        }
    end
    bikeMenu[#bikeMenu+1] = {
        header = "< Go Back",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(bikeMenu)
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for k, v in pairs(Config.Locations) do
            local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
            if dist < 50.0 then
				DrawMarker(Config.TypeMarker, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerScale, Config.MarkerScale, Config.MarkerScale, 0, 200, 250, 100, false, false, false, true, false, false, false)
                if dist < 1.5 then
                    if IsPedInAnyVehicle(ped, false) then
						if GetVehicleClass(GetVehiclePedIsIn(ped, false)) == 13 then
							DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.7, "Press [~g~E~s~] to Store Bike")
						end
                    else
                        DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.7, "Press [~g~E~s~] to Rent a Bike")
                    end
                    if IsControlJustReleased(0, 38) then
						if havebike and IsPedInAnyVehicle(ped, false) then
							if GetVehicleClass(GetVehiclePedIsIn(ped, false)) == 13 then
								DoScreenFadeOut(1000)
								QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(ped))
								DoScreenFadeIn(2000)
								QBCore.Functions.Notify("Thanks for returning the bike!", "success", 3000)
								havebike = false
							end
						elseif havebike and not IsPedInAnyVehicle(ped, false) then
							QBCore.Functions.Notify("You did not return the bike you rented!", "error", 3000)
						elseif not havebike and IsPedInAnyVehicle(ped, false) then
							if GetVehicleClass(GetVehiclePedIsIn(ped, false)) == 13 then
								QBCore.Functions.Notify("You did not rent a bike!", "error", 3000)
							end
						elseif not havebike and not IsPedInAnyVehicle(ped, false) then
							OpenBikesMenu()
						end
                    end
                end
           	end
        end
        Wait(1)
    end
end)