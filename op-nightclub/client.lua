function DrawText3Ds(x, y, z, text)
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
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function CreateDj(dj) 
    if dj == "solomun" then
        model = "csb_sol"
    elseif dj == "dixon" then
        model = "csb_dix"
	elseif dj == "taleofus" then
		local random = math.random(1,2)
		if random == 1 then
			model = "csb_talmm"
		else
			model = "csb_talcc"
		end
	elseif dj == "theblackmadonna" then
		model = "csb_djblamadon"
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local ped = CreatePed(26, model, -1604.664, -3012.583, -79.9999, 268.9422, false, false)
    SetEntityHeading(ped, 268.9422)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(model) 

    return ped
end

function CleanUpInterior(interiorID)
    for k,v in pairs(Config.InteriorsProps) do
        if IsInteriorPropEnabled(interiorID, v) then
            DisableInteriorProp(interiorID, v)
            Wait(10)
        end
    end
      
    StopAudioScenes()
    ReleaseScriptAudioBank()
    Wait(200)
    RefreshInterior(interiorID)
    UnpinInterior(interiorID)
end

function PrepareClubInterior(interiorID)
    for k,v in pairs(Config.InteriorsProps) do
        if not IsInteriorPropEnabled(interiorID, v) then
            EnableInteriorProp(interiorID, v)
            Wait(30)
        end
    end

    if DoesEntityExist(dj) then
        DeleteEntity(dj)
    end

    RequestScriptAudioBank("DLC_BATTLE/BTL_CLUB_OPEN_TRANSITION_CROWD", false, -1)
    SetAmbientZoneState("IZ_ba_dlc_int_01_ba_Int_01_main_area", 0, 0)
    Wait(100)
    RefreshInterior(interiorID)
    IsPedInNightClub = true
end

function RenderScreenModel(name, model)
    local handle = 0

    if not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, 0)
    end
    
    if not IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end

    if IsNamedRendertargetRegistered(name) then
        handle = GetNamedRendertargetRenderId(name)
    end

    return handle
end

IsPlayerNearClub = false
IsPedInNightClub = false

Citizen.CreateThread(function()
    DoScreenFadeIn(100)

    local coords = Config.NightclubLocation
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 136)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 27)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Omega Nightclub")
    EndTextCommandSetBlipName(blip)
    if not IsIplActive(Config.Banner) then
        RequestIpl(Config.Banner)
    end

    if not IsIplActive(Config.Barrier) then
        RequestIpl(Config.Barrier)
    end
end)

local JustTeleported = false
CreateThread(function()
    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for loc,_ in pairs(Config.Teleports) do
            for k, v in pairs(Config.Teleports[loc]) do
                local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                if dist < 5 then
                    inRange = true
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 128, 0, 128, 255, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 2.0 then
                        DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.25, v.drawText)
                        if IsControlJustReleased(0, 51) and not JustTeleported then
                            if k == 1 then
								DoScreenFadeOut(1000)
								while not IsScreenFadedOut() do
									Wait(10)
								end
								interiorID = GetInteriorAtCoordsWithType(-1604.664, -3012.583, -79.9999, "ba_dlc_int_01_ba")
								if IsValidInterior(interiorID) then
									LoadInterior(interiorID)
									while not IsInteriorReady(interiorID) do
										Wait(100)
									end
									if IsInteriorReady(interiorID) then
										PrepareClubInterior(interiorID)
										if not DoesEntityExist(dj) then
											dj = CreateDj(Config.CurrentDJ)
										end
										SetEntityCoords(ped, Config.Teleports[loc][2].coords.x, Config.Teleports[loc][2].coords.y, Config.Teleports[loc][2].coords.z)
										SetGameplayCamRelativeHeading(12.1322)
										SetGameplayCamRelativePitch(-3.2652, 1065353216)
										DoScreenFadeIn(300)
										Wait(350)
										StartAudioScene("DLC_Ba_NightClub_Scene")
										PlaySoundFrontend(-1, "club_crowd_transition", "dlc_btl_club_open_transition_crowd_sounds", true)
									end
								end
								Wait(1000)
								DoScreenFadeIn(1500)
								JustTeleported = true
								ResetTeleport()
                            elseif k == 2 then
								DoScreenFadeOut(1000)
								while not IsScreenFadedOut() do
									Wait(10)
								end
								CleanUpInterior(interiorID)
                                SetEntityCoords(ped, Config.Teleports[loc][1].coords.x, Config.Teleports[loc][1].coords.y, Config.Teleports[loc][1].coords.z)
								IsPedInNightClub = false
								Wait(1000)
								DoScreenFadeIn(1500)
								JustTeleported = true
								ResetTeleport()
                            end
						end
                    end
                end
            end
        end

        if not inRange then
            Wait(1000)
        end

        Wait(3)
    end
end)

function ResetTeleport()
    SetTimeout(2500, function()
        JustTeleported = false
    end)
end

Citizen.CreateThread(function ()
    local model = GetHashKey("ba_prop_club_screens_01");
    sHandle = RenderScreenModel("club_projector", model)
    Wait(500)

    RegisterScriptWithAudio(0)
	if Config.CurrentDJ == "solomun" then
		Citizen.InvokeNative(0x9DD5A62390C3B735, 2, "PL_SOL_RIB_PALACE", 0)
	elseif Config.CurrentDJ == "taleofus" then
		Citizen.InvokeNative(0x9DD5A62390C3B735, 2, "PL_TAL_RIB_PALACE", 0)
	elseif Config.CurrentDJ == "dixon" then
		Citizen.InvokeNative(0x9DD5A62390C3B735, 2, "PL_DIX_RIB_PALACE", 0)
	elseif Config.CurrentDJ == "theblackmadonna" then
		Citizen.InvokeNative(0x9DD5A62390C3B735, 2, "PL_MAD_RIB_PALACE", 0)
	end
	SetTvChannel(2)
	SetTvAudioFrontend(0)
	while true do
		Wait(1)
		if IsPedInNightClub then
			SetTextRenderId(sHandle)
			SetScriptGfxDrawOrder(4)
			SetScriptGfxDrawBehindPausemenu(1)
			DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
			SetTextRenderId(GetDefaultScriptRendertargetRenderId())
        end
    end
end)