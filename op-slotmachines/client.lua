local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData		= QBCore.Functions.GetPlayerData()

local closetoSlots		= false
local Slots 					= {}
local Spins 					= {}
local selectedSlot			= nil
local SITTING_SCENE 			= nil
local CURRENT_CHAIR_DATA 		= nil
local SELECTED_CHAIR_ID 		= nil
local ACTIVE_SLOT				= nil
local currentBetAmount 		= 0

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

Citizen.CreateThread(function()
	while true do
		local playerCoords = GetEntityCoords(GetPlayerPed(-1))
		closetoSlots = false
		for k, v in pairs(Config.Slots) do
			if #(playerCoords - Config.Slots[k].pos) < 20.0 then
				closetoSlots = true
			end
		end
		Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while not closetoSlots do
		Citizen.Wait(10)
	end

	for slotIndex, data in pairs(Config.Slots) do
		createSlots(slotIndex, data)
	end
end)

createSlots = function(index, data)
	local self = {}

    self.index = index
    self.data = data
	self.betData = {}
	self.rulettCam = nil
	
	self.spin1 = nil
	self.spin2 = nil
	self.spin3 = nil
	
	self.spin1b = nil
	self.spin2b = nil
	self.spin3b = nil
	
	self.running = false
	self.cameraMode = 1
	self.tableObject = GetClosestObjectOfType(data.pos,0.8,GetHashKey(self.data.prop),0,0,0)
	--SetEntityHeading(self.tableObject, -80.0)
	
	self.data.rot = GetEntityHeading(self.tableObject)
	self.data.position = GetEntityCoords(self.tableObject)
	
	self.offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject),0.0, 0.05, 0.0)
	
	self.changeKameraMode = function()
		local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
		if self.cameraMode == 1 then
			self.cameraMode = 2
			local CamOffset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.50, -0.60, 0.54)
			self.rulettCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', CamOffset.x, CamOffset.y, CamOffset.z+0.8, rot.x-25.0, rot.y, rot.z+35.0, 80.0, true, 2)SetCamActive(self.rulettCam, true)
			RenderScriptCams(true, 900, 900, true, false)
			ShakeCam(self.rulettCam, 'HAND_SHAKE', 0.3)
		elseif self.cameraMode == 2 then
			self.cameraMode = 3
			if DoesCamExist(self.rulettCam) then
				DestroyCam(self.rulettCam, false)
			end			
			RenderScriptCams(false, 900, 900, true, false)
		elseif self.cameraMode == 3 then
			self.cameraMode = 1
			local CamOffset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.0, -0.5, 0.6)
			self.rulettCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', CamOffset.x, CamOffset.y, CamOffset.z+0.8, rot.x-25.0, rot.y, rot.z, 85.0, true, 2)SetCamActive(self.rulettCam, true)
			RenderScriptCams(true, 900, 900, true, false)
			ShakeCam(self.rulettCam, 'HAND_SHAKE', 0.3)
		end
    end

	self.startPlaying = function(state)
		if state then
			Citizen.Wait(3000)
			FreezeEntityPosition(PlayerPedId(), true)
			self.cameraMode = 1
			
			local sex = 0
			local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
			if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then sex = 1 end
			local L = 'anim_casino_a@amb@casino@games@slots@male'
			if sex == 1 then
				L = 'anim_casino_a@amb@casino@games@slots@female'
			end
			RequestAnimDict(L)
			while not HasAnimDictLoaded(L) do
				Citizen.Wait(1)
			end
			SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
			local rndspin = ({'base_idle_a', 'base_idle_b', 'base_idle_c', 'base_idle_d', 'base_idle_e', 'base_idle_f'})[math.random(1, 6)]
			NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,L,rndspin,2.0,2.0,13,16,2.0,0)
			NetworkStartSynchronisedScene(SITTING_SCENE)
			
			model = GetHashKey(self.data.prop1)
			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Wait(0)
			end
		
			model = GetHashKey(self.data.prop2)
			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Wait(0)
			end
		
			local rot = vector3(0.0, 0.0, self.data.rot + 0.0)
			local Offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.0, -0.5, 0.6)
			local CamOffset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.0, -0.5, 0.6)
			
			
			local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject),-0.118, 0.05, 0.9)
			local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.000, 0.05, 0.9)
			local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.118, 0.05, 0.9)
			
			
			selectedSlot = self.index
			
			self.spin1 = CreateObject(GetHashKey(self.data.prop1), Offset1.x, Offset1.y, Offset1.z, true, true)
			self.spin2 = CreateObject(GetHashKey(self.data.prop1), Offset2.x, Offset2.y, Offset2.z, true, true)
			self.spin3 = CreateObject(GetHashKey(self.data.prop1), Offset3.x, Offset3.y, Offset3.z, true, true)
			
			table.insert(Spins, self.spin1)
			table.insert(Spins, self.spin2)
			table.insert(Spins, self.spin3)
			
			SetEntityAsMissionEntity(self.spin1, true, true)
			SetEntityAsMissionEntity(self.spin2, true, true)
			SetEntityAsMissionEntity(self.spin3, true, true)
			
			SetEntityHeading(self.spin1, self.data.rot)
			SetEntityHeading(self.spin2, self.data.rot)
			SetEntityHeading(self.spin3, self.data.rot)
			
			
			self.rulettCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', CamOffset.x, CamOffset.y, CamOffset.z+0.8, rot.x-25.0, rot.y, rot.z, 85.0, true, 2)
			SetCamActive(self.rulettCam, true)
			ShakeCam(self.rulettCam, 'HAND_SHAKE', 0.3)
			RenderScriptCams(true, 900, 900, true, false)
			
			Citizen.CreateThread(function()
				while selectedSlot ~= nil do
					Citizen.Wait(0)
					
					DisableKeys()
					
					if IsDisabledControlJustPressed(0, 38) then     --E to go into chair
						self.changeKameraMode()
					end
						
					if IsDisabledControlJustPressed(0, 194) then	-- BACKSPACE
						if Config.HideUI then
							TriggerEvent(Config.ShowUIEvent)
						end
						ACTIVE_SLOT = nil
						DeleteSlots(self.spin1, self.spin2, self.spin3)
						DeleteSlots2(Spins)
						self.startPlaying(false)
						self.spin1 = GetClosestObjectOfType(Offset.x-0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
						self.spin2 = GetClosestObjectOfType(Offset.x+0.000, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
						self.spin3 = GetClosestObjectOfType(Offset.x+0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
					end
					if IsDisabledControlJustPressed(0, 191) or IsDisabledControlJustPressed(0, 22) then	-- SPIN
						if not self.running then
							self.running = true
							startRulett(self.index, self.data)
							self.spin1 = GetClosestObjectOfType(Offset.x-0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
							self.spin2 = GetClosestObjectOfType(Offset.x+0.000, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
							self.spin3 = GetClosestObjectOfType(Offset.x+0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
						end
					end
					TriggerEvent("op-slotmachines:client:sendMessage", "Press BACKSPACE to leave\nPress ENTER or SPACE Spin\nPress E to change camera\nBet: ~y~" .. tostring(self.data.bet) .. "~w~ Chips", 10000)
				end
			end)
            Citizen.Wait(2000)
		else
			if DoesCamExist(self.rulettCam) then
				DestroyCam(self.rulettCam, false)
			end
			
			FreezeEntityPosition(PlayerPedId(), false)
			
			RenderScriptCams(false, 900, 900, true, false)
			selectedSlot = nil
			
			local sex = 0
			local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
			if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then sex = 1 end
			local L = 'anim_casino_a@amb@casino@games@slots@male'
			if sex == 1 then
				L = 'anim_casino_a@amb@casino@games@slots@female'
			end
			RequestAnimDict(L)
			while not HasAnimDictLoaded(L) do
				Citizen.Wait(1)
			end
			SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
			local rndspin = ({'exit_left', 'exit_right'})[math.random(1, 2)]
			NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,L,rndspin,2.0,2.0,13,16,0,0)
			NetworkStartSynchronisedScene(SITTING_SCENE)
			Citizen.Wait(3000)
			ClearPedTasks(GetPlayerPed(-1))
			TriggerServerEvent('casino:slots:notUsing', self.index)
		end
	end
	
	self.spin = function(tickRate)
		local sex = 0; local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
		if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then sex = 1 end
		local L = 'anim_casino_a@amb@casino@games@slots@male'; if sex == 1 then L = 'anim_casino_a@amb@casino@games@slots@female' end
		RequestAnimDict(L) while not HasAnimDictLoaded(L) do Citizen.Wait(1) end
		SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
		local rndspin = ({'press_spin_a', 'press_spin_b'})[math.random(1, 2)]
		NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,L,rndspin,2.0,2.0,50,16,2.0,0)
		NetworkStartSynchronisedScene(SITTING_SCENE)
		
		Citizen.Wait(500)
		
		DeleteSlots(self.spin1, self.spin2, self.spin3)
		DeleteSlots2(Spins)
		
		local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject),-0.118, 0.05, 0.9)
		local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.000, 0.05, 0.9)
		local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.118, 0.05, 0.9)
		
		self.spin1b = CreateObject(GetHashKey(self.data.prop2), Offset1.x, Offset1.y, Offset1.z, true, true)
		self.spin2b = CreateObject(GetHashKey(self.data.prop2), Offset2.x, Offset2.y, Offset2.z, true, true)
		self.spin3b = CreateObject(GetHashKey(self.data.prop2), Offset3.x, Offset3.y, Offset3.z, true, true)
		table.insert(Spins, self.spin1b); table.insert(Spins, self.spin2b); table.insert(Spins, self.spin3b);
		SetEntityAsMissionEntity(self.spin1b, true, true)
		SetEntityAsMissionEntity(self.spin2b, true, true)
		SetEntityAsMissionEntity(self.spin3b, true, true)
		
		SetEntityHeading(self.spin1b, self.data.rot); SetEntityHeading(self.spin2b, self.data.rot); SetEntityHeading(self.spin3b, self.data.rot);
		local temp1 = GetEntityRotation(self.spin1b)
		local temp2 = GetEntityRotation(self.spin2b)
		local temp3 = GetEntityRotation(self.spin3b)
		
		SetEntityRotation(self.spin1b, temp1.x+math.random(0,360)-180.0, temp1.y, temp1.z, 0, true)
		SetEntityRotation(self.spin2b, temp2.x+math.random(0,360)-180.0, temp2.y, temp2.z, 0, true)
		SetEntityRotation(self.spin3b, temp3.x+math.random(0,360)-180.0, temp3.y, temp3.z, 0, true)
		
		for i=1,300,1 do
			local h1 = GetEntityRotation(self.spin1b)
			local h2 = GetEntityRotation(self.spin2b)
			local h3 = GetEntityRotation(self.spin3b)
			
			if i < 180 then
				SetEntityRotation(self.spin1b, h1.x+math.random(40,100)/10, h1.y, h1.z, 0, true)
			elseif i == 180 then
				h1 = GetEntityRotation(self.spin1b); DeleteSlot(self.spin1b)
				self.spin1 = CreateObject(GetHashKey(self.data.prop1), Offset1.x, Offset1.y, Offset1.z, true, true)
				table.insert(Spins, self.spin1)
				SetEntityAsMissionEntity(self.spin1, true, true)
				SetEntityHeading(self.spin1, self.data.rot); SetEntityRotation(self.spin1, tickRate.a*22.5-180+0.0, h1.y, h1.z, 0, true)
			end
							
							
			if i < 240 then
				SetEntityRotation(self.spin2b, h2.x+math.random(40,100)/10, h2.y, h2.z, 0, true)
			elseif i == 240 then
				h2 = GetEntityRotation(self.spin2b); DeleteSlot(self.spin2b)
				self.spin2 = CreateObject(GetHashKey(self.data.prop1), Offset2.x, Offset2.y, Offset2.z, true, true)
				table.insert(Spins, self.spin2)
				SetEntityAsMissionEntity(self.spin2, true, true)
				SetEntityHeading(self.spin2, self.data.rot); SetEntityRotation(self.spin2, tickRate.b*22.5-180+0.0, h2.y, h2.z, 0, true)
			end
							
							
			if i < 300 then
				SetEntityRotation(self.spin3b, h3.x+math.random(40,100)/10, h3.y, h3.z, 0, true)
			elseif i == 300 then
				h3 = GetEntityRotation(self.spin3b);DeleteSlot(self.spin3b)
				self.spin3 = CreateObject(GetHashKey(self.data.prop1), Offset3.x, Offset3.y, Offset3.z, true, true)
				table.insert(Spins, self.spin3)
				SetEntityAsMissionEntity(self.spin3, true, true)
				SetEntityHeading(self.spin3, self.data.rot); SetEntityRotation(self.spin3, tickRate.c*22.5-180+0.0, h3.y, h3.z, 0, true)
				local rndidle = ({'idle_a', 'idle_a=b'})[math.random(1, 2)]
				NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,'anim_casino_b@amb@casino@games@shared@player@',rndidle,2.0,2.0,50,16,2.0,0)
				NetworkStartSynchronisedScene(SITTING_SCENE)
			end				
			Citizen.Wait(10)
			
		end
		self.running = false
		if Config.PrintClient then
			print(Config.Wins[tickRate.a] or 'MISS', Config.Wins[tickRate.b] or 'MISS', Config.Wins[tickRate.c] or 'MISS')
		end
		TriggerServerEvent('op-slotmachines:server:slotsCheckWin', self.index, tickRate, self.data)
	end
	
	Slots[self.index] = self
end

function DeleteSlots(a, b, c)
	DeleteEntity(a)
	DeleteObject(a)
	while DoesEntityExist(a) do
		Wait(0)
		SetEntityAsMissionEntity(a, true, true)
		DeleteEntity(a)
		DeleteObject(a)
	end
	
	DeleteEntity(b)
	DeleteObject(b)
	while DoesEntityExist(b) do
		Wait(0)
		SetEntityAsMissionEntity(b, true, true)
		DeleteEntity(b)
		DeleteObject(b)
	end
	
	DeleteEntity(c)
	DeleteObject(c)
	while DoesEntityExist(c) do
		Wait(0)
		SetEntityAsMissionEntity(c, true, true)
		DeleteEntity(c)
		DeleteObject(c)
	end
end

function DeleteSlots2(a)
	for k,v in pairs(Spins) do 
		DeleteEntity(v)
		DeleteObject(v)
		while DoesEntityExist(v) do
			Wait(0)
			SetEntityAsMissionEntity(v, true, true)
			DeleteEntity(v)
			DeleteObject(v)
		end
	end
end

function DeleteSlot(a)
	DeleteEntity(a)
	DeleteObject(a)
	while DoesEntityExist(a) do
		Wait(0)
		SetEntityAsMissionEntity(vehicle, true, true)
		DeleteEntity(a)
		DeleteObject(a)
	end
end

function startRulett(index, data)
    if Slots[index] then
        TriggerServerEvent("op-slotmachines:server:taskStartSlots", index, data)
    end
end

function DisableKeys()
	DisableControlAction(0, 38, true)
	DisableControlAction(0, 23, true)
	DisableControlAction(0, 75, true)
	DisableControlAction(0, 323, true)
	DisableControlAction(0, 113, true)
	DisableControlAction(0, 288, true)
	DisableControlAction(0, 289, true)
	DisableControlAction(0, 170, true)
	DisableControlAction(0, 166, true)
	DisableControlAction(0, 167, true)
	DisableControlAction(0, 168, true)
	DisableControlAction(0, 56, true)
	DisableControlAction(0, 57, true)
	DisableControlAction(0, 47, true)
	DisableControlAction(0, 73, true)
	DisableControlAction(0, 36, true)
	DisableControlAction(0, 21, true)
	DisableControlAction(0, 178, true)
	DisableControlAction(0, 18, true)
	DisableControlAction(0, 177, true)
	DisableControlAction(0, 201, true)
	DisableControlAction(0, 108, true)
	DisableControlAction(0, 60, true)
	DisableControlAction(0, 107, true)
	DisableControlAction(0, 117, true)
	DisableControlAction(0, 61, true)
	DisableControlAction(0, 118, true)
	DisableControlAction(0, 22, true)
end

RegisterNetEvent('op-slotmachines:server:startSpin')
AddEventHandler('op-slotmachines:server:startSpin',function(index, tickRate)
	if Slots[index] ~= nil then
		Slots[index].spin(tickRate)
	end
end)

-- AddEventHandler('esx:onPlayerDeath', function()
	-- if Slots[ACTIVE_SLOT] then
		-- Slots[ACTIVE_SLOT].startPlaying(false)
		-- DeleteSlots2(Spins)
	-- end
-- end)

Citizen.CreateThread(function()
	while true do
		local letSleep = true
		if QBCore ~= nil then
			local playerpos = GetEntityCoords(PlayerPedId())
			if closetoSlots and selectedSlot == nil then
				for k, v in pairs(Slots) do
					if DoesEntityExist(v.tableObject) then
						local objcoords = GetEntityCoords(v.tableObject)
						local dist = Vdist(playerpos, objcoords)
						if dist < 2.0 then
							letSleep = false
							local closestChairData = getClosestChairData(v.tableObject)
							if closestChairData == nil then
								break
							end
							--DrawMarker(20,closestChairData.position + vector3(0.0, 0.0, 1.0),0.0,0.0,0.0,180.0,0.0,0.0,0.2,0.2,0.2,255,255,255,255,false,true,2,true,nil,nil,false)
							DrawText3D(closestChairData.position.x, closestChairData.position.y, closestChairData.position.z + 1, "Press [~g~E~w~] to play slots (Minimum bet: " .. tostring(v.data.bet) .. " Chips)")
							if IsControlJustPressed(0, 38) then
								QBCore.Functions.TriggerCallback('op-slotmachines:server:isSeatUsed', function(used)
									if not used then
										if Config.HideUI then
											TriggerEvent(Config.HideUIEvent)
										end
										ACTIVE_SLOT = v.index
										SELECTED_CHAIR_ID = closestChairData.chairId
										CURRENT_CHAIR_DATA = closestChairData
										SITTING_SCENE = NetworkCreateSynchronisedScene(closestChairData.position, closestChairData.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
										RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
										while not HasAnimDictLoaded('anim_casino_b@amb@casino@games@shared@player@') do
											Citizen.Wait(1)
										end
										local randomSit = ({'sit_enter_left', 'sit_enter_right'})[math.random(1, 2)]
										NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,'anim_casino_b@amb@casino@games@shared@player@',randomSit,2.0,-2.0,13,16,2.0,0)
										NetworkStartSynchronisedScene(SITTING_SCENE)
										startSlot(k, closestChairData.chairId)
									end
								end,v.index)
							end
							break
						end
					else
						for slotIndex, data in pairs(Config.Slots) do
							createSlots(slotIndex, data)
						end
					end
				end
			end
		end
		if letSleep then
			Citizen.Wait(1000)
		end
		Citizen.Wait(1)
	end
end)

function changeBetAmount(amount)
    currentBetAmount = amount
end

function startSlot(index, chairId)
    if Slots[index] then
        Slots[index].startPlaying(true)
    end
end

function getClosestChairData(tableObject)
    local localPlayer = PlayerPedId()
    local playerpos = GetEntityCoords(localPlayer)
    if DoesEntityExist(tableObject) then
        local objcoords = GetWorldPositionOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, 'Chair_Base_01'))
		local dist = Vdist(playerpos, objcoords)
		if dist < 1.7 then
			return {
				position = objcoords,
				rotation = GetWorldRotationOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, 'Chair_Base_01')),
				chairId = 1,
				obj = tableObject
			}
		end
    end
end

RegisterNetEvent("op-slotmachines:client:sendMessage")
AddEventHandler("op-slotmachines:client:sendMessage", function(msg)
    DisplayHelpText(msg, 15000)
end)

RegisterNetEvent("op-slotmachines:client:notify")
AddEventHandler("op-slotmachines:client:notify", function(msg)
    QBCore.Functions.Notify(msg, 3500)
end)

function DisplayHelpText(helpText, time)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringWebsite(helpText)
	EndTextCommandDisplayHelp(0, 0, 1, time or -1)
end