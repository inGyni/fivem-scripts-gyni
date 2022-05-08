local QBCore = exports["qb-core"]:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerJob = PlayerData.job
        isLoggedIn = true
    end
end)

local function GetPedGender()
    local gender = "Male"
    if PlayerData.charinfo.gender == 1 then gender = "Female" end
    return gender
end

local function GetDirectionText(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return 'North Bound'
    elseif (heading >= 45 and heading < 135) then
        return 'South Bound'
    elseif (heading >= 135 and heading < 225) then
        return 'East Bound'
    elseif (heading >= 225 and heading < 315) then
        return 'West Bound'
    end
end

function GetStreetAndZone()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local area = GetLabelText(tostring(GetNameOfZone(coords.x, coords.y, coords.z)))
    local playerStreetsLocation = area
    if not zone then zone = "UNKNOWN" end
    if currentStreetName ~= nil and currentStreetName ~= "" then playerStreetsLocation = currentStreetName .. ", " ..area
    else playerStreetsLocation = area end
    return playerStreetsLocation
end

Citizen.CreateThread(function()
    local cooldown = 0
    local isBusy = false
	while true do
		Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsPedShooting(playerPed) and (cooldown == 0 or cooldown - GetGameTimer() < 0) and not isBusy and PlayerData.job.name ~= "hunter" then
            print("Shooting")
            isBusy = true
            if not IsPedCurrentWeaponSilenced(playerPed) then
                cooldown = GetGameTimer() + math.random(15000, 20000)
                TriggerEvent("op-dispatch:gunshot")
            end
            isBusy = false
        end
    end
end)

RegisterNetEvent("op-dispatch:createBlip", function(type, coords)
    if type == "bankrobbery" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 161)
        SetBlipColour(Blip, 46)
        SetBlipScale(Blip, 1.5)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Bank Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "storerobbery" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 52)
        SetBlipColour(Blip, 1)
        SetBlipScale(Blip, 1.5)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Store Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "houserobbery" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 411)
        SetBlipColour(Blip, 1)
        SetBlipScale(Blip, 1.5)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 House Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "jewelrobbery" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 434)
        SetBlipColour(Blip, 66)
        SetBlipScale(Blip, 1.5)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Vangelico Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "jailbreak" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 487)
        SetBlipColour(Blip, 4)
        SetBlipScale(Blip, 1.5)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-98 Jail Break In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "carjacking" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 488)
        SetBlipColour(Blip, 1)
        SetBlipScale(Blip, 1.5)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Vehicle Theft In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "gunshot" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-60 Shots Fired')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end	
    elseif type == "officerdown" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 162)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-99 Officer in Distress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "drugsell" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 162)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-51 Drug Sale')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "atmrobbery" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 162)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 ATM Robbery')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "casinorobbery" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 679)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Casino Alarms')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "civdown" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Injured Person')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "artrobbery" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipSprite(Blip, 269)
        SetBlipColour(Blip, 59)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Art Gallery Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "humanerobbery" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipSprite(Blip, 499)
        SetBlipColour(Blip, 2)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Humane Labs Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "trainrobbery" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipSprite(Blip, 795)
        SetBlipColour(Blip, 59)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Train Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "vanrobbery" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipSprite(Blip, 67)
        SetBlipColour(Blip, 59)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Security Van Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "undergroundrobbery" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipSprite(Blip, 486)
        SetBlipColour(Blip, 59)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Underground Tunnels Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "drugboatrobbery" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipSprite(Blip, 427)
        SetBlipColour(Blip, 26)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-31 Suspicious Activity On Boat')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    elseif type == "unionrobbery" then
        local alpha = 250
        local Blip = AddBlipForRadius(coords, 75.0)
        SetBlipSprite(Blip, 500)
        SetBlipColour(Blip, 60)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('10-90 Union Depository Robbery In Progress')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end	
    elseif type == "911call" then
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip, 480)
        SetBlipColour(Blip, 1)
        SetBlipScale(Blip, 1.2)
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('911 Call')
        EndTextCommandSetBlipName(Blip)
        while alpha ~= 0 do
            Citizen.Wait(120 * 4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    end
end)

RegisterNetEvent("dispatch:clNotify", function(data, id)
    SendNUIMessage({
        update = "newCall",
        callID = id,
        data = data,
        timer = 5000
    })
end)

RegisterNetEvent("op-dispatch:officerdown", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-99",
        fullname = PlayerData.charinfo.firstname,
        callSign = PlayerData.metadata["callsign"],
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "10-99 Officer in Distress"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:officerdown", currentPos)
end)

RegisterNetEvent("op-dispatch:bankrobbery", function(camId)
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        camId = camId,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Bank Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:bankrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:storerobbery", function(camId)
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        camId = camId,
        priority = 2,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Store Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:storerobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:houserobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 2,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "House Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:houserobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:jewelrobbery", function(camId)
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        camId = camId,
        priority = 2,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Vangelico Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:jewelrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:jailbreak", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-98",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Jail Break"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:jailbreak", currentPos)
end)

RegisterNetEvent("op-dispatch:carjacking", function(data)
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        model = data.model,
        plate = data.plate,
        firstColor = data.firstColor,
        heading = GetDirectionText(data.heading),
        priority = 3,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Vehicle Theft"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:carjacking", currentPos)
end)

RegisterNetEvent("op-dispatch:gunshot", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-60",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 2,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Shots Fired"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:gunshot", currentPos)
end)

RegisterNetEvent("op-dispatch:drugsell", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-51",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 3,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Possible Drug Dealing"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:drugsell", currentPos)
end)

RegisterNetEvent("op-dispatch:atmrobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 2,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "ATM Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:atmrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:civdown", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-60",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 2,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Injured Person"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:civdown", currentPos)
end)

RegisterNetEvent("op-dispatch:artrobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Art Gallery Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:artrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:humanerobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Humane Labs Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:humanerobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:trainrobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Train Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:trainrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:vanrobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Security Van Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:vanrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:undergroundrobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Underground Tunnels Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:undergroundrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:drugboatrobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-31",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Suspicious Activity On Boat"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:drugboatrobbery", currentPos)
end)

RegisterNetEvent("op-dispatch:unionrobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Union Depository Robbery"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:unionrobbery", currentPos)
end)


RegisterNetEvent("op-dispatch:911call", function(message)
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = GetPedGender()
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "911",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 2,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = message
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:911call", currentPos)
end)

RegisterNetEvent("op-dispatch:casinorobbery", function()
    local playerPed = PlayerPedId()
    local currentPos = GetEntityCoords(playerPed)
    local gender = IsPedMale(playerPed)
    TriggerServerEvent('dispatch:svNotify', {
        dispatchCode = "10-90",
        firstStreet = GetStreetAndZone(),
        gender = gender,
        priority = 1,
        origin = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
        dispatchMessage = "Casino Alarms"
    })
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("op-dispatch:casinorobbery", currentPos)
end)
