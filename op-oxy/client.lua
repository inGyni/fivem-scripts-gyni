QBCore = exports["qb-core"]:GetCoreObject()

local onDelivery = false
local deliveryVehicle = nil

local deliveryLocation = 0
local deliveryPed = 0
local currentBlip = nil
local returnBlip = nil
local deliveriesDone = 0
local moneyEarnings = 0
local oxyEarnings = 0
local returnLocation = nil
local trips = nil

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function SpawnOxyVehicle()
	if DoesEntityExist(deliveryVehicle) then
	    SetVehicleHasBeenOwnedByPlayer(deliveryVehicle, false)
		SetEntityAsNoLongerNeeded(deliveryVehicle)
		DeleteEntity(deliveryVehicle)
	end
    local car = Config.Cars[math.random(#Config.Cars)].model
    QBCore.Functions.LoadModel(car)
    local spawnpoint = Config.CarSpawns[math.random(#Config.CarSpawns)].coords

    deliveryVehicle = CreateVehicle(car, spawnpoint.x, spawnpoint.y, spawnpoint.z, spawnpoint.w, true, false)
	SetVehicleHasBeenOwnedByPlayer(deliveryVehicle, true)
	TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(deliveryVehicle))
    while true do
    	Citizen.Wait(1)
		DrawText3Ds(spawnpoint.x, spawnpoint.y, spawnpoint.z, "Delivery Vehicle")
		if #(GetEntityCoords(PlayerPedId()) - vector3(spawnpoint.x, spawnpoint.y, spawnpoint.z)) < 8.0 then
			return
		end
    end

end

function CreateOxyPed()
    local hashKey = Config.OxyPeds[math.random(#Config.OxyPeds)].model
    local pedType = 5
	QBCore.Functions.LoadModel(hashKey)
	deliveryPed = CreatePed(pedType, hashKey, Config.OxyDropOffs[deliveryLocation].coords.x,Config.OxyDropOffs[deliveryLocation].coords.y,Config.OxyDropOffs[deliveryLocation].coords.z, Config.OxyDropOffs[deliveryLocation].coords.w, 0, 0)
    ClearPedTasks(deliveryPed)
    ClearPedSecondaryTask(deliveryPed)
    SetPedFleeAttributes(deliveryPed, 0, 0)
    SetPedCombatAttributes(deliveryPed, 17, 1)
    SetPedSeeingRange(deliveryPed, 0.0)
    SetPedHearingRange(deliveryPed, 0.0)
    SetPedAlertness(deliveryPed, 0)
    SetPedKeepTask(deliveryPed, true)
	FreezeEntityPosition(deliveryPed, true)
	SetEntityInvincible(deliveryPed, true)
	SetBlockingOfNonTemporaryEvents(deliveryPed, true)
end

function DeleteCreatedPed()
	if DoesEntityExist(deliveryPed) then 
		SetPedKeepTask(deliveryPed, false)
		TaskSetBlockingOfNonTemporaryEvents(deliveryPed, false)
		ClearPedTasks(deliveryPed)
		TaskWanderStandard(deliveryPed, 10.0, 10)
		SetPedAsNoLongerNeeded(deliveryPed)
		Citizen.Wait(2000)
		deliveryPed = nil
	end
end

function DeleteBlip()
	if DoesBlipExist(currentBlip) then
		RemoveBlip(currentBlip)
	end
end

function CreateBlip()
	DeleteBlip()
	if OxyRun then
		currentBlip = AddBlipForCoord(Config.OxyDropOffs[deliveryLocation].coords.x,Config.OxyDropOffs[deliveryLocation].coords.y,Config.OxyDropOffs[deliveryLocation].coords.z)
	end
    SetBlipSprite(currentBlip, 514)
    SetBlipColour(currentBlip, 59)
    SetBlipScale(currentBlip, 1.0)
    SetBlipAsShortRange(currentBlip, true)
	SetBlipRoute(currentBlip, true)
	SetBlipRouteColour(currentBlip, 59)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop Off")
    EndTextCommandSetBlipName(currentBlip)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

function giveAnim()
    if DoesEntityExist(deliveryPed) and not IsEntityDead(deliveryPed) then
        loadAnimDict("mp_safehouselost@")
        if IsEntityPlayingAnim(deliveryPed, "mp_safehouselost@", "package_dropoff", 3) then 
            TaskPlayAnim(deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        else
            TaskPlayAnim(deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        end     
    end
end

function DoDropOff()
	local success = true
	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then
			success = true
		else
			success = false
		end
	end, "oxy")
	Wait(500)
	playerAnim()
	Citizen.Wait(800)
	PlayAmbientSpeech1(deliveryPed, "Chat_State", "Speech_Params_Force")
	if DoesEntityExist(deliveryPed) and not IsEntityDead(deliveryPed) then
		giveAnim()
		Wait(2000)
		DeleteBlip()
		if success then
			deliveriesDone = deliveriesDone + 1
			local money = math.random(Config.MinimumPayment, Config.MaximumPayment)
			TriggerServerEvent("op-oxy:server:deliverOxy", money)
			moneyEarnings = moneyEarnings + money
			QBCore.Functions.Notify("Oxy delivered successfully, you received $".. tostring(money), 'success', 3500)
			Wait(100)
		else
			QBCore.Functions.Notify("You don't any oxy, delivery cancelled, please return the vehicle.", "error", 3500)
			tasking = false
			OxyRun = false
			TriggerEvent("op-oxy:client:endDeliveries")
		end
		DeleteCreatedPed()
	end
end

RegisterNetEvent("op-oxy:client:startOxyRun")
AddEventHandler("op-oxy:client:startOxyRun", function()
	if tasking then
		return
	end
	deliveryLocation = math.random(1, #Config.OxyDropOffs)
	CreateBlip()
	local pedCreated = false
	tasking = true
	local timer = 600000
	while tasking do
		Citizen.Wait(10)
		if not pedCreated then
			pedCreated = true
			DeleteCreatedPed()
			CreateOxyPed()
		end
		timer = timer - 10
		if timer < 0 then
		    SetVehicleHasBeenOwnedByPlayer(deliveryVehicle, false)
			SetEntityAsNoLongerNeeded(deliveryVehicle)
			tasking = false
			OxyRun = false
			QBCore.Functions.Notify('You are ran out of time. Oxy run failed.', 'success', 5000)
		end
		local pedPos = GetEntityCoords(deliveryPed)
		local plrPos = GetEntityCoords(PlayerPedId())
		if #(plrPos - pedPos) < 3.0 and pedCreated then
			DrawText3Ds(pedPos.x, pedPos.y, pedPos.z, "Press [~g~E~w~] to deliver package")
			if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0, 38) then
				TaskTurnPedToFaceEntity(deliveryPed, PlayerPedId(), 1.0)
				Citizen.Wait(100)
				PlayAmbientSpeech1(deliveryPed, "Generic_Hi", "Speech_Params_Force")
				DoDropOff()
				tasking = false
			end
		end
	end
	DeleteCreatedPed()
	DeleteBlip()

end)

local workers = {}
Citizen.CreateThread(function()
	for k, v in pairs(Config.DealerLocations) do
		local hashKey = Config.OxyPeds[math.random(#Config.OxyPeds)].model
		QBCore.Functions.LoadModel(hashKey)
		local worker = CreatePed(5, hashKey, v.coords.x, v.coords.y, v.coords.z - 1, v.heading, false, true)
		FreezeEntityPosition(worker, true)
		SetEntityInvincible(worker, true)
		SetBlockingOfNonTemporaryEvents(worker, true)
		local data = {
			ped = worker,
			coords = GetEntityCoords(worker),
		}
		table.insert(workers, data)
	end
end)

Citizen.CreateThread(function()
    while true do
	    Citizen.Wait(10)
		local pos = GetEntityCoords(PlayerPedId())
		for k, v in pairs(workers) do
			if #(pos - v.coords) < 2.5 and not OxyRun then
				DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "Press [~g~E~w~] to start an Oxy run for $" .. Config.StartPayment) 
				if IsControlJustReleased(0,38) then
					trips = math.random(Config.MinimumTrips, Config.MaximumTrips)
					TriggerServerEvent("op-oxy:server:startOxyRun", trips)
				end
			end
		end
    end

end)

Citizen.CreateThread(function()
    while true do
        if OxyRun then
			if not DoesEntityExist(deliveryVehicle) or GetVehicleEngineHealth(deliveryVehicle) < 200.0 or GetVehicleBodyHealth(deliveryVehicle) < 200.0 then
				OxyRun = false
				tasking = false
				QBCore.Functions.Notify('The dealer will not give you more locations due to the state of the car..', 'error', 3500)
			else
				if tasking then
			        Wait(2000)
			    else
					Wait(100)
				    if deliveriesDone >= trips then
						QBCore.Functions.Notify("You've finished all your deliveries. Go back to the dealer to deliver the vehicle and get the rest of your money." , 'primary', 7500)
				    	OxyRun = false
						TriggerEvent("op-oxy:client:endDeliveries")
					else
						TriggerEvent("op-oxy:client:startOxyRun")
						Wait(3000)
						QBCore.Functions.Notify('A new location has been marked for you.', 'primary', 5000)
					end
				end
			end
	    end
		Wait(10)
    end
end)

RegisterNetEvent("op-oxy:client:startDealing")
AddEventHandler("op-oxy:client:startDealing", function()
    local NearNPC = GetClosestPed()
	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
	deliveriesDone = 0
	OxyRun = true
	QBCore.Functions.Notify('Your car is waiting outside.', 'success', 3500)
	SpawnOxyVehicle()
end)

RegisterNetEvent("op-oxy:client:endDeliveries")
AddEventHandler("op-oxy:client:endDeliveries", function()
	DeleteBlip()
	returnLocation = Config.ReturnLocation[math.random(#Config.ReturnLocation)].coords
	returnBlip = AddBlipForCoord(returnLocation.x, returnLocation.y, returnLocation.z)
    SetBlipSprite(returnBlip, 225)
    SetBlipColour(returnBlip, 59)
    SetBlipScale(returnBlip, 1.0)
    SetBlipAsShortRange(returnBlip, true)
	SetBlipRoute(returnBlip, true)
	SetBlipRouteColour(returnBlip, 59)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Return Vehicle")
    EndTextCommandSetBlipName(returnBlip)
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
		if returnLocation then
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			if #(pos - returnLocation) < 4.5 then
				DrawText3Ds(returnLocation.x, returnLocation.y, returnLocation.z, "Press [~g~E~w~] to return vehicle")
				if IsControlJustReleased(0, 38) then
					if GetVehiclePedIsIn(ped, false) == deliveryVehicle then
						DeleteVehicle(deliveryVehicle)
						returnLocation = nil
						RemoveBlip(returnBlip)
						if deliveriesDone == trips then
							QBCore.Functions.Notify("Successfully delivered all packages, well done.", "success", 3500)
							TriggerServerEvent("op-oxy:server:getDebtBack", Config.StartPayment)
						elseif deliveriesDone < trips then
							QBCore.Functions.Notify("You did not deliver all the packages. Taking the remaining packages.", "primary", 3500)
							TriggerServerEvent("op-oxy:server:removeRemainingOxy", trips - deliveriesDone)
							TriggerServerEvent("op-oxy:server:getDebtBack", ((Config.StartPayment / trips) * deliveriesDone))
						end
					else
						QBCore.Functions.Notify("This is not the delivery vehicle, please return the correct vehicle.", "error", 3500)
					end
				end
			end
		end
	end
end)
