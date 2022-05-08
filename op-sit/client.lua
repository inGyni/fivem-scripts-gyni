local QBCore = exports['qb-core']:GetCoreObject()
local sitting = false
local lastPos = nil
local currentSitCoords = nil
local currentScenario = nil
local occupied = {}
local disableControls = false
local currentObj = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			GetUp()
		end

		if (IsControlJustPressed(0, 38) -- E
		or IsControlJustPressed(0, 32) -- W
		or IsControlJustPressed(0, 33) -- S
		or IsControlJustPressed(0, 34) -- A
		or IsControlJustPressed(0, 35) -- D
		or IsControlJustPressed(0, 22)) -- SPACE
		and IsInputDisabled(0) and IsPedOnFoot(playerPed) then
			if sitting then
				GetUp()
			end			
		end
	end
end)

Citizen.CreateThread(function()
	local Sitables = {}

	for k, v in pairs(Config.Sitable) do
		local model = GetHashKey(k)
		table.insert(Sitables, model)
	end
	Citizen.Wait(100)
	exports['qb-target']:AddTargetModel(Sitables, {
        options = {
            {
                event = "op-sit:client:sit",
                icon = "fas fa-chair",
                label = "Sit",
				entity = entity
            },
        },
        distance = 2.5
    })
end)

RegisterNetEvent("op-sit:client:sit", function(data)
	local playerPed = PlayerPedId()

	if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
		GetUp()
	end

	if disableControls then
		DisableControlAction(1, 37, true)
	end

	local object = data.entity
	local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(object))

	if distance and distance < 2.0 then
		local hash = GetEntityModel(object)

		for k,v in pairs(Config.Sitable) do
			if GetHashKey(k) == hash then
				Sit(object, k, v)
				break
			end
		end
	end
end)


function GetUp()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(PlayerPedId())

	TaskStartScenarioAtPosition(playerPed, currentScenario, 0.0, 0.0, 0.0, 180.0, 2, true, false)
	while IsPedUsingScenario(PlayerPedId(), currentScenario) do
		Citizen.Wait(100)
	end
	ClearPedTasks(playerPed)

	FreezeEntityPosition(playerPed, false)
	FreezeEntityPosition(currentObj, false)
	TriggerServerEvent('op-sit:server:getUp', currentSitCoords)
	currentSitCoords = nil
	currentScenario = nil
	sitting = false
	disableControls = false
end

function Sit(object, modelName, data)
	if not HasEntityClearLosToEntity(PlayerPedId(), object, 17) then
		return
	end
	disableControls = true
	currentObj = object
	FreezeEntityPosition(object, true)

	PlaceObjectOnGroundProperly(object)
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(PlayerPedId())

	QBCore.Functions.TriggerCallback('op-sit:server:isSeatTaken', function(occupied)
		if occupied then
			QBCore.Functions.Notify('Someone is already sitting there.', 'error', 3500)
		else
			local playerPed = PlayerPedId()
			lastPos = GetEntityCoords(playerPed)
			currentSitCoords = pos
			TriggerServerEvent('op-sit:server:sitDown', pos)
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, false)
			
			Citizen.Wait(2500)
			if GetEntitySpeed(PlayerPedId()) > 0 then
				ClearPedTasks(playerPed)
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
			end
			sitting = true
		end
	end, pos)
end