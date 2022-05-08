JustTeleported = false

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

CreateThread(function()
    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for loc,_ in pairs(Config.Teleports) do
            for k, v in pairs(Config.Teleports[loc]) do
                local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                if dist < v.markerRange then
                    inRange = true
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, v.color.x, v.color.y, v.color.z, v.color.w, 0, 0, 0, 1, 0, 0, 0)
                    if dist < v.teleportRange then
                        DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.25, v.drawText)
                        if IsControlJustReleased(0, 51) and not JustTeleported then
                            if k == 1 then
								DoScreenFadeOut(1000)
								while not IsScreenFadedOut() do
									Wait(10)
								end
                                SetEntityCoords(ped, Config.Teleports[loc][2].coords.x, Config.Teleports[loc][2].coords.y, Config.Teleports[loc][2].coords.z)
								SetEntityHeading(ped, Config.Teleports[loc][2].coords.w)
								Wait(1000)
								DoScreenFadeIn(1500)
                            elseif k == 2 then
								DoScreenFadeOut(1000)
								while not IsScreenFadedOut() do
									Wait(10)
								end
                                SetEntityCoords(ped, Config.Teleports[loc][1].coords.x, Config.Teleports[loc][1].coords.y, Config.Teleports[loc][1].coords.z)
                                SetEntityHeading(ped, Config.Teleports[loc][1].coords.w)
								Wait(1000)
								DoScreenFadeIn(1500)
                            end
                            ResetTeleport()
						end
                    end
                end
            end
        end

        if not inRange then
            Wait(100)
        end

        Wait(3)
    end
end)

function ResetTeleport()
    SetTimeout(2500, function()
        JustTeleported = false
    end)
end
