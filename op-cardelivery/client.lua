local QBCore = exports['qb-core']:GetCoreObject()

local isWorking = false
local vehicle = nil
local gotVehicle = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    StartScript()
end)

AddEventHandler('onResourceStart', function(resource)
    StartScript()
end)

function StartScript()
    CreateThread(function()
        Citizen.Wait(100)
        RequestModel(Config.PedModel)
        while not HasModelLoaded(Config.PedModel) do
            Citizen.Wait(10)
        end
        local npc = CreatePed(4, Config.PedModel, Config.NpcCoords.x, Config.NpcCoords.y, Config.NpcCoords.z - 1, Config.NpcHeading, false, true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        TaskStartScenarioInPlace(npc, "WORLD_HUMAN_DRUG_DEALER", 0, true)
    end)
end

function StartDelivery()
    CreateThread(function()
        local locationSelected = nil
        local vehicleChoice = math.random(1, #Config.Vehicles)
        local model = GetHashKey(Config.Vehicles[vehicleChoice].model)
        local player = PlayerPedId()

        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(10)
        end

        if #Config.Locations >= 1 then
            locationSelected = math.random(1, #Config.Locations)
        else
            locationSelected = #Config.Locations
        end

        vehicle = CreateVehicle(model, Config.Locations[locationSelected].startCoords.x, Config.Locations[locationSelected].startCoords.y, Config.Locations[locationSelected].startCoords.z, Config.Locations[locationSelected].startCoords.w, true, true)
        local netid = NetworkGetNetworkIdFromEntity(vehicle)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetNetworkIdCanMigrate(netid, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleNeedsToBeHotwired(vehicle, true)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(model)

        local vehBlip = AddBlipForEntity(vehicle)
        SetBlipSprite(vehBlip, 523)
        SetBlipRoute(vehBlip, true)
        SetBlipColour(vehBlip, 6)
        SetBlipRouteColour(vehBlip, 6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vehicle Location")
        EndTextCommandSetBlipName(vehBlip)

        QBCore.Functions.Notify("Find a " .. Config.Vehicles[vehicleChoice].name .. " at " .. Config.Locations[locationSelected].start, "success", 5000)

        while not gotVehicle do
            Wait(1000)
            if GetVehiclePedIsIn(PlayerPedId(), false) == vehicle then
                gotVehicle = true
                SetBlipRoute(vehBlip, false)
                RemoveBlip(vehBlip)
                QBCore.Functions.Notify("Deliver this vehicle to " .. Config.Locations[locationSelected].finish, "success", 5000)
            end
        end
        
        local destinationBlip = AddBlipForCoord(Config.Locations[locationSelected].finishCoords.x, Config.Locations[locationSelected].finishCoords.y, Config.Locations[locationSelected].finishCoords.z)
        SetBlipSprite(destinationBlip, 523)
        SetBlipRoute(destinationBlip, true)
        SetBlipColour(destinationBlip, 6)
        SetBlipRouteColour(destinationBlip, 6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Delivery Location")
        EndTextCommandSetBlipName(destinationBlip)
        
        while gotVehicle do
            Wait(10)
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - Config.Locations[locationSelected].finishCoords) < 5 then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    DrawText3D(Config.Locations[locationSelected].finishCoords.x, Config.Locations[locationSelected].finishCoords.y, Config.Locations[locationSelected].finishCoords.z, "Press [~g~E~w~] to delivery vehicle!")
                    if IsControlJustPressed(0, 38) then
                        if GetVehiclePedIsIn(PlayerPedId(), false) == vehicle then
                            DeliverVehicle()
                            SetBlipRoute(destinationBlip, false)
                            RemoveBlip(destinationBlip)
                        end
                    end
                end
            end
        end
    end)
end

function DeliverVehicle()
    local extraPoints = GetVehicleEngineHealth(vehicle) + GetVehicleBodyHealth(vehicle)
    TaskLeaveVehicle(PlayerPedId(), vehicle, 256)
    Citizen.Wait(2000)
    local reward = math.floor(math.random(2500, 4000) + (extraPoints * 4))
    TriggerServerEvent("op-cardelivery:server:AddMoney", reward)
    QBCore.Functions.Notify("You earned $" .. reward .. " for delivering this vehicle!", "success", 3500)
    QBCore.Functions.DeleteVehicle(vehicle)
    gotVehicle = false
    isWorking = false
end

CreateThread(function()
    while true do
        Citizen.Wait(10)
        local pos = GetEntityCoords(PlayerPedId())
        if #(pos - Config.NpcCoords) < 5 then
            if IsControlJustPressed(0, 38) then
                if isWorking then
                    isWorking = false
                    QBCore.Functions.Notify("You quit the car delivery job!", "error", 3000)
                    QBCore.Functions.DeleteVehicle(vehicle)
                    Citizen.Wait(500)
                else 
                    isWorking = true
                    QBCore.Functions.Notify("You started a car delivery job!", "success", 3000)
                    StartDelivery()
                    Citizen.Wait(500)
                end
            end
            if not isWorking then
                DrawText3D(Config.NpcCoords.x, Config.NpcCoords.y, Config.NpcCoords.z, "Press [~g~E~w~] to start a delivery job")
            else
                DrawText3D(Config.NpcCoords.x, Config.NpcCoords.y, Config.NpcCoords.z, "Press [~g~E~w~] to quit the delivery job")
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end