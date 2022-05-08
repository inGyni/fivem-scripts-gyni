local QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}
local pedspawned = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
function QBCore.Functions.GetPlayerData(cb)
    if cb then
        cb(QBCore.PlayerData)
    else
        return QBCore.PlayerData
    end
end

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
     	PlayerData.job = job
end)

RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(val)
	PlayerData = val
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.GaragePedLocations) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
			
			if dist < 40 and not pedspawned then
				TriggerEvent('op-burgershot:spawn:ped', v.coords)
				pedspawned = true
			end
			if dist >= 35 then
				pedspawned = false
				DeletePed(npc)
			end
		end
	end
end)

RegisterNetEvent('op-burgershot:spawn:ped')
AddEventHandler('op-burgershot:spawn:ped',function(coords)
	local hash = `ig_floyd`

	RequestModel(hash)
	while not HasModelLoaded(hash) do 
		Wait(10)
	end

    pedspawned = true
    npc = CreatePed(5, hash, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)
    FreezeEntityPosition(npc, true)
    FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
    loadAnimDict("amb@world_human_cop_idles@male@idle_b") 
     TaskPlayAnim(npc, "amb@world_human_cop_idles@male@idle_b", "idle_e", 8.0, 1.0, -1, 17, 0, 0, 0, 0)
end)

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end
end

RegisterNetEvent('op-burgershot:garage')
AddEventHandler('op-burgershot:garage', function(bs)
    local vehicle = bs.vehicle
    local coords = vector4(-1172.861, -888.4072, 13.940833, 40.516719)
        if PlayerData.job.name == "burgershot" then
            if vehicle == 'stalion2' then		
                QBCore.Functions.SpawnVehicle(vehicle, function(veh)
                    SetVehicleNumberPlateText(veh, "BUR "..tostring(math.random(1000, 9999)))
                    exports['LegacyFuel']:SetFuel(veh, 100.0)
                    SetEntityHeading(veh, coords.w)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                    SetVehicleEngineOn(veh, true, true)
                end, coords, true)
            end
        else
            QBCore.Functions.Notify('You are not an employee of BurgerShot.', 'error')
        end
end)

RegisterNetEvent('op-burgershot:storecar')
AddEventHandler('op-burgershot:storecar', function()
    QBCore.Functions.Notify('Work Vehicle Stored!')
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    NetworkFadeOutEntity(car, true,false)
    Citizen.Wait(2000)
    QBCore.Functions.DeleteVehicle(car)
end)

RegisterNetEvent('garage:BurgerShotGarage', function()
    exports['qb-menu']:openMenu({
        {
            header = "| BurgerShot Garage |",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "• Stallion",
            txt = "Declasse Burger Shot Stallion",
            params = {
                event = "op-burgershot:garage",
                args = {
                    vehicle = 'stalion2',
                }
            }
        },
        {
            header = "• Store Vehicle",
            txt = "Store Vehicle Inside Garage",
            params = {
                event = "op-burgershot:storecar",
                args = {
                    
                }
            }
        },	
        {
            header = "Close (ESC)",
            isMenuHeader = true,
        },	
    })
end)
