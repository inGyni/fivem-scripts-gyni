local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local ownedProperties = {}

------------------------------------------------ FUNCTIONS ------------------------------------------------

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

RegisterNetEvent("op-properties:client:UpdateProperties", function()
    QBCore.Functions.TriggerCallback("op-properties:server:GetProperties", function(data)
        ownedProperties = data
        for i=1, #ownedProperties do
            SetBlipColour(Config.Properties[ownedProperties[i].propertyIndex].blip, 2)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Owned " .. Config.Properties[ownedProperties[i].propertyIndex].blipName)
            EndTextCommandSetBlipName(Config.Properties[ownedProperties[i].propertyIndex].blip)
        end
    end)
end)

------------------------------------------------ INTIALIZING EVENTS ------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        PlayerData = QBCore.Functions.GetPlayerData()
        TriggerEvent("op-properties:client:UpdateProperties")
    end
end)

AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerEvent("op-properties:client:UpdateProperties")
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
    PlayerData = nil
    propertyid = nil
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(JobInfo)
    PlayerData = QBCore.Functions.GetPlayerData()
end)


------------------------------------------------ EVENTS ------------------------------------------------

RegisterNetEvent("op-properties:client:depositMoney", function(data)
    local dialog = exports['qb-input']:ShowInput({
		header = "Deposit " .. data.moneyType .. " money",
		submitText = "Deposit",
		inputs = {
			{
				text = "Amount to Deposit",
				name = "amount",
				type = "number",
				isRequired = true,
			}
		}
	})
	if dialog then
		if not dialog.amount then return end
		TriggerServerEvent('op-properties:server:depositMoney', tonumber(dialog.amount), data.moneyType, data.amount, data.propertyId)
	end
end)

RegisterNetEvent("op-properties:client:withdrawMoney", function(data)
    local dialog = exports['qb-input']:ShowInput({
		header = "Withdraw " .. data.moneyType .. " money",
		submitText = "Withdraw",
		inputs = {
			{
				text = "Amount to Withdraw",
				name = "amount",
				type = "number",
				isRequired = true,
			}
		}
	})
	if dialog then
		if not dialog.amount then return end
		TriggerServerEvent('op-properties:server:withdrawMoney', tonumber(dialog.amount), data.moneyType, data.amount, data.propertyId)
	end
end)

RegisterNetEvent("op-properties:client:manageCashMenu", function(data)
    local cashMenu = {
        {
            header = data.moneyType .. " Cash",
            isMenuHeader = true,
        }
    }
    cashMenu[#cashMenu+1] = {
        header = "Deposit " .. data.moneyType .. " cash",
        txt = "",
        params = {
            event = "op-properties:client:depositMoney",
            args = {
                moneyType = data.moneyType,
                amount = data.amount,
                propertyId = data.propertyId
            }
        },
    }
    cashMenu[#cashMenu+1] = {
        header = "Withdraw " .. data.moneyType .. " Cash",
        txt = "",
        params = {
            event = "op-properties:client:withdrawMoney",
            args = {
                moneyType = data.moneyType,
                amount = data.amount,
                propertyId = data.propertyId
            }
        },
    }
    cashMenu[#cashMenu + 1] = {
        header = "< Go Back",
        txt = "",
        params = {
            event = "op-properties:client:OpenSafe"
        }
    }
    exports['qb-menu']:openMenu(cashMenu)
end)

RegisterNetEvent("op-properties:client:OpenSafe", function(propertyId)
    QBCore.Functions.TriggerCallback("op-properties:server:GetSafeMoney", function(data)
        local illegalMoney = data.illegalMoney or 0
        local legalMoney = data.legalMoney or 0
        local safeMenu = {
            {
                header = "Property Safe",
                isMenuHeader = true,
            }
        }
        safeMenu[#safeMenu+1] = {
            header = "Illegal Cash: $" .. illegalMoney,
            txt = "Manage Illegal Cash",
            params = {
                event = "op-properties:client:manageCashMenu",
                args = {
                    amount = illegalMoney,
                    moneyType = "illegal",
                    propertyId = propertyId
                }
            },
        }
        safeMenu[#safeMenu+1] = {
            header = "Legal Cash: $" .. legalMoney,
            txt = "Manage Legal Cash",
            params = {
                event = "op-properties:client:manageCashMenu",
                args = {
                    amount = legalMoney,
                    moneyType = "legal",
                    propertyId = propertyId
                }
            },
        }
        safeMenu[#safeMenu + 1] = {
            header = "< Exit",
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu"
            }
        }
        exports['qb-menu']:openMenu(safeMenu)
    end, propertyId)
end)

RegisterNetEvent("op-properties:client:OpenStorage", function(propertyid, data)
    if propertyid ~= nil and data ~= nil then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", propertyid, data)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Stash", 0.4)
        TriggerEvent("inventory:client:SetCurrentStash", propertyid)
    end
end)

------------------------------------------------ THREADS ------------------------------------------------

------------------ BLIPS ------------------

Citizen.CreateThread(function()
    for i=1, #Config.Properties do
        local blip = AddBlipForCoord(Config.Properties[i].blipCoords)
        local sprite = Config.Properties[i].type == "house" and Config.HouseBlipSprite or Config.OfficeBlipSprite
        SetBlipSprite(blip, sprite)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.62)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Properties[i].blipName)
        EndTextCommandSetBlipName(blip)
        Config.Properties[i].blip = blip
    end
end)


------------------ DOOR THREAD ------------------
local JustTeleported = false
---------- ENTRANCE ----------
Citizen.CreateThread(function()
    Wait(5000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i=1, #ownedProperties do
            local property = Config.Properties[ownedProperties[i].propertyIndex]
            if #(pos - property.outdoorCoords) < 10 then
                DrawMarker(2, property.outdoorCoords.x, property.outdoorCoords.y, property.outdoorCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 0, 200, 250, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - property.outdoorCoords) < 2.5 then
                    if ownedProperties[i].propertyId ~= nil then
                        DrawText3D(property.outdoorCoords.x, property.outdoorCoords.y, property.outdoorCoords.z + 0.25, "Press [~g~E~w~] to enter your " .. property.type)
                        if IsControlJustPressed(0, 38) and not JustTeleported then
                            JustTeleported = true
                            DoScreenFadeOut(1000)
                            while not IsScreenFadedOut() do
                                Wait(10)
                            end
                            SetEntityCoords(ped, property.indoorCoords.x, property.indoorCoords.y, property.indoorCoords.z)
                            Wait(1000)
                            DoScreenFadeIn(1500)
                            SetTimeout(5000, function()
                                JustTeleported = false
                            end)
                        end
                    end
                end
            end
        end
        Wait(1)
    end
end)

---------- EXIT ----------

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i=1, #ownedProperties do
            local property = Config.Properties[ownedProperties[i].propertyIndex]
            if #(pos - property.indoorCoords) < 10 then
                DrawMarker(2, property.indoorCoords.x, property.indoorCoords.y, property.indoorCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 0, 200, 250, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - property.indoorCoords) < 2.5 then
                    DrawText3D(property.indoorCoords.x, property.indoorCoords.y, property.indoorCoords.z + 0.25, "Press [~g~E~w~] to leave your " .. property.type)
                    if IsControlJustPressed(0, 38) and not JustTeleported then
                        JustTeleported = true
                        DoScreenFadeOut(1000)
						while not IsScreenFadedOut() do
						    Wait(10)
					    end
                        SetEntityCoords(ped, property.outdoorCoords.x, property.outdoorCoords.y, property.outdoorCoords.z)
						Wait(1000)
						DoScreenFadeIn(1500)
                        SetTimeout(5000, function()
                            JustTeleported = false
                        end)
                    end
                end
            end
        end
        Wait(1)
    end
end)

------------------ CHARACTER LOG THREAD ------------------

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i=1, #ownedProperties do
            local property = Config.Properties[ownedProperties[i].propertyIndex]
            if #(pos - property.characterLog) < 7.5 then
                DrawMarker(2, property.characterLog.x, property.characterLog.y, property.characterLog.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 0, 200, 250, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - property.characterLog) < 1.75 then
                    DrawText3D(property.characterLog.x, property.characterLog.y, property.characterLog.z + 0.25, "Press [~g~E~w~] to log out your character")
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("op-properties:server:Logout")
                    end
                end
            end
        end
        Wait(1)
    end
end)

------------------ STORAGE THREAD ------------------

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i=1, #ownedProperties do
            local property = Config.Properties[ownedProperties[i].propertyIndex]
            if #(pos - property.storageCoords) < 7.5 then
                DrawMarker(2, property.storageCoords.x, property.storageCoords.y, property.storageCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 0, 200, 250, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - property.storageCoords) < 1.75 then
                    DrawText3D(property.storageCoords.x, property.storageCoords.y, property.storageCoords.z + 0.25, "Press [~g~E~w~] to access your storage")
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("op-properties:client:OpenStorage", "property".. ownedProperties[i].propertyId, { maxweight = property.StashWeight * 1000, slots = property.StashSlots })
                    end
                end
            end
        end
        Wait(1)
    end
end)


------------------ SAFE THREAD ------------------

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i=1, #ownedProperties do
            local property = Config.Properties[ownedProperties[i].propertyIndex]
            if #(pos - property.safeCoords) < 7.5 then
                DrawMarker(2, property.safeCoords.x, property.safeCoords.y, property.safeCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 0, 200, 250, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - property.safeCoords) < 1.75 then
                    DrawText3D(property.safeCoords.x, property.safeCoords.y, property.safeCoords.z + 0.25, "Press [~g~E~w~] to access your safe")
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("op-properties:client:OpenSafe", ownedProperties[i].propertyId)
                    end
                end
            end
        end
        Wait(1)
    end
end)

------------------ CLOTHING THREAD ------------------

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for i=1, #ownedProperties do
            local property = Config.Properties[ownedProperties[i].propertyIndex]
            if #(pos - property.clothingCoords) < 7.5 then
                DrawMarker(2, property.clothingCoords.x, property.clothingCoords.y, property.clothingCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 0, 200, 250, 255, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - property.clothingCoords) < 1.75 then
                    DrawText3D(property.clothingCoords.x, property.clothingCoords.y, property.clothingCoords.z + 0.25, "Press [~g~E~w~] to change your clothing")
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('qb-clothing:client:openOutfitMenu')
                    end
                end
            end
        end
        Wait(1)
    end
end)