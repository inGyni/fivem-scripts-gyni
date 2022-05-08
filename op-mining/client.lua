local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local PlayerJob = {}
local blips = {}

local peds = {}
local shopPeds = {}

local function ManageBlips()
	if PlayerJob.name == "miner" then
		for k, v in pairs(Config.Locations) do
			if Config.Locations[k].blipTrue then
				local blip = AddBlipForCoord(v.location)
				SetBlipAsShortRange(blip, true)
				SetBlipSprite(blip, 527)
				SetBlipColour(blip, 81)
				SetBlipScale(blip, 0.7)
				SetBlipDisplay(blip, 6)
				BeginTextCommandSetBlipName('STRING')
				if Config.BlipNamer then
					AddTextComponentString(Config.Locations[k].name)
				else
					AddTextComponentString(tostring(Loc[Config.Lan].info["blip_mining"]))
				end
				EndTextCommandSetBlipName(blip)
				table.insert(blips, blip)
			end
		end
	else
		for i=1, #blips do
			RemoveBlip(blips[i])
		end
	end
end

AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		PlayerData = QBCore.Functions.GetPlayerData()
		PlayerJob = PlayerData.job
		ManageBlips()
	end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
	PlayerJob = PlayerData.job
	ManageBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData = QBCore.Functions.GetPlayerData()
	PlayerJob = PlayerData.job
	ManageBlips()
end)

Citizen.CreateThread(function()
	local isLoaded = false
	while not isLoaded do
		Wait(2000)
		isLoaded = true
	end
	if isLoaded then
		CreateModelHide(vector3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)
		if Config.PropSpawn == true then
			if minelight1 == nil then
				RequestModel(GetHashKey("prop_worklight_03a"))
				while not HasModelLoaded(GetHashKey("prop_worklight_03a")) do Citizen.Wait(1) end
				local minelight1 = CreateObject(GetHashKey("prop_worklight_03a"),-593.29, 2093.22, 131.7-1.05,false,false,false)
				SetEntityHeading(minelight1,GetEntityHeading(minelight1)-80)
				FreezeEntityPosition(minelight1, true)
			end		
			if minelight2 == nil then
				RequestModel(GetHashKey("prop_worklight_03a"))
				while not HasModelLoaded(GetHashKey("prop_worklight_03a")) do Citizen.Wait(1) end
				local minelight2 = CreateObject(GetHashKey("prop_worklight_03a"),-604.55, 2089.74, 131.15-1.05,false,false,false)
				SetEntityHeading(minelight2,GetEntityHeading(minelight2)-260)
				FreezeEntityPosition(minelight2, true)
			end

			local prop = 0
			for k,v in pairs(Config.OrePositions) do
				prop = prop+1
				local prop = CreateObject(GetHashKey("cs_x_rubweec"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
				SetEntityHeading(prop,GetEntityHeading(prop)-90)
				FreezeEntityPosition(prop, true)           
			end
			for k,v in pairs(Config.MineLights) do
				prop = prop+1
				local prop = CreateObject(GetHashKey("xs_prop_arena_lights_ceiling_l_c"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)

				FreezeEntityPosition(prop, true)           
			end
			
			local bench = CreateObject(GetHashKey("gr_prop_gr_bench_04b"),Config.Locations['JewelCut'].location,false,false,false)
			SetEntityHeading(bench,GetEntityHeading(bench)-Config.Locations['JewelCut'].heading)
			FreezeEntityPosition(bench, true)

			local bench2 = CreateObject(GetHashKey("prop_tool_bench02"),Config.Locations['Cracking'].location,false,false,false)
			SetEntityHeading(bench2,GetEntityHeading(bench2)-Config.Locations['Cracking'].heading)
			FreezeEntityPosition(bench2, true)

			local bench2prop = CreateObject(GetHashKey("cs_x_rubweec"),Config.Locations['Cracking'].location.x, Config.Locations['Cracking'].location.y, Config.Locations['Cracking'].location.z+0.83,false,false,false)
			SetEntityHeading(bench2prop,GetEntityHeading(bench2prop)-Config.Locations['Cracking'].heading+90)
			FreezeEntityPosition(bench2prop, true)
			local bench2prop2 = CreateObject(GetHashKey("prop_worklight_03a"),Config.Locations['Cracking'].location.x-1.4, Config.Locations['Cracking'].location.y+1.08, Config.Locations['Cracking'].location.z,false,false,false)
			SetEntityHeading(bench2prop2,GetEntityHeading(bench2prop2)-Config.Locations['Cracking'].heading+180)
			FreezeEntityPosition(bench2prop2, true)
		end
		if Config.Pedspawn == true then
			while true do
				Citizen.Wait(500)
				for k = 1, #Config.PedList, 1 do
					v = Config.PedList[k]
					local playerCoords = GetEntityCoords(PlayerPedId())
					local dist = #(playerCoords - v.coords)
					if dist < Config.Distance and not peds[k] then
						local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
						peds[k] = {ped = ped}
					end
					if dist >= Config.Distance and peds[k] then
						if Config.Fade then
							for i = 255, 0, -51 do
								Citizen.Wait(50)
								SetEntityAlpha(peds[k].ped, i, false)
							end
						end
						DeletePed(peds[k].ped)
						peds[k] = nil
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------


function nearPed(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		--print(Lang:t("warning.print_no_gender"))
	end
	if Config.MinusOne then 
		local x, y, z = table.unpack(coords)
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
		table.insert(shopPeds, ped)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
		table.insert(shopPeds, ped)
	end
	SetEntityAlpha(ped, 0, false)
	if Config.Frozen then
		FreezeEntityPosition(ped, true) --Don't let the ped move.
	end
	if Config.Invincible then
		SetEntityInvincible(ped, true) --Don't let the ped die.
	end
	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	end
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	if Config.Fade then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end
	return ped
end

-----------------------------------------------------------

Citizen.CreateThread(function()
	exports['qb-target']:AddCircleZone("MineShaft", Config.Locations['Mine'].location, 2.0, { name="MineShaft", debugPoly=false, useZ=true, }, 
	{ options = { { event = "op-mining:openShop", icon = "fas fa-certificate", label = Loc[Config.Lan].info["browse_store"], job = "miner", }, }, 
		distance = 2.0
	})
	exports['qb-target']:AddCircleZone("Quarry", Config.Locations['Quarry'].location, 2.0, { name="Quarry", debugPoly=false, useZ=true, }, 
	{ options = { { event = "op-mining:openShop", icon = "fas fa-certificate", label = Loc[Config.Lan].info["browse_store"], job = "miner", }, },
		distance = 2.0
	})
	--Smelter to turn stone into ore
	exports['qb-target']:AddCircleZone("Smelter", Config.Locations['Smelter'].location, 3.0, { name="Smelter", debugPoly=false, useZ=true, }, 
	{ options = { { event = "op-mining:SmeltMenu", icon = "fas fa-certificate", label = Loc[Config.Lan].info["use_smelter"], job = "miner", }, },
		distance = 10.0
	})
	--Ore Buyer
	exports['qb-target']:AddCircleZone("Buyer", Config.Locations['Buyer'].location, 2.0, { name="Buyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "op-mining:SellOre", icon = "fas fa-certificate", label = Loc[Config.Lan].info["sell_ores"], job = "miner", },	},
		distance = 2.0
	})
	--Jewel Cutting Bench
	exports['qb-target']:AddCircleZone("JewelCut", Config.Locations['JewelCut'].location, 2.0, { name="JewelCut", debugPoly=false, useZ=true, }, 
	{ options = { { event = "op-mining:JewelCut", icon = "fas fa-certificate", label = Loc[Config.Lan].info["jewelcut"], job = "miner", },	},
		distance = 2.0
	})
	--Jewel Buyer
	exports['qb-target']:AddCircleZone("JewelBuyer", Config.Locations['Buyer2'].location, 2.0, { name="JewelBuyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "op-mining:JewelSell", icon = "fas fa-certificate", label = Loc[Config.Lan].info["jewelbuyer"], job = "miner", },	},
		distance = 2.0
	})
	--Cracking Bench
	exports['qb-target']:AddCircleZone("CrackingBench", Config.Locations['Cracking'].location, 2.0, { name="CrackingBench", debugPoly=false, useZ=true, }, 
	{ options = { { event = "op-mining:CheckHasStone", icon = "fas fa-certificate", label = Loc[Config.Lan].info["crackingbench"], job = "miner", }	},
		distance = 2.0
	})
	local ore = 0
	for k,v in pairs(Config.OrePositions) do
		ore = ore+1
		exports['qb-target']:AddCircleZone(ore, v.coords, 2.0, { name=ore, debugPoly=false, useZ=true, }, 
		{ options = { { event = "op-mining:MineOre", icon = "fas fa-certificate", label = Loc[Config.Lan].info["mine_ore"], job = "miner", },	},
			distance = 2.5
		})
	end
end)

-----------------------------------------------------------
--Mining Store Opening
RegisterNetEvent('op-mining:openShop', function ()
	TriggerServerEvent("inventory:server:OpenInventory", "shop", "mine", Config.Items)
end)
------------------------------------------------------------
-- Mine Ore Command / Animations

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

local mining = false

RegisterNetEvent('op-mining:MineOre', function ()
	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then
			mining = true
		else
			mining = false
			TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_drill"], 'error')
		end
	end, "drill")
end)

Citizen.CreateThread(function()
	while true do
		if mining then
			RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
			RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
			RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
			soundId = GetSoundId()
			local pos = GetEntityCoords(PlayerPedId())
			loadAnimDict("anim@heists@fleeca_bank@drilling")
			TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
			local pos = GetEntityCoords(PlayerPedId(), true)
			local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
			AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
			PlaySoundFromEntity(soundId, "Drill", DrillObject, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
			QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["drilling_ore"], math.random(2500,5000), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				SetEntityAsMissionEntity(DrillObject)--nessesary for gta to even trigger DetachEntity
				StopSound(soundId)
				Wait(5)
				DetachEntity(DrillObject, true, true)
				Wait(5)
				DeleteObject(DrillObject)
				TriggerServerEvent('op-mining:MineReward')
				IsDrilling = false
				TriggerEvent("op-mining:MineOre")
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				StopSound(soundId)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
				IsDrilling = false
				mining = false
			end)
			Wait(5000)
		end
		Wait(1000)
	end
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking

local cracking = false

RegisterNetEvent('op-mining:CheckHasStone', function ()
	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then
			cracking = true
		else 
			cracking = false
			TriggerEvent('QBCore:Notify', Loc[Config.Lan].info["no_stone"], 'error')
		end 
	end, "stone")
end)

Citizen.CreateThread(function()
	while true do
		if cracking then
			local pos = GetEntityCoords(GetPlayerPed(-1))
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			QBCore.Functions.Progressbar("open_locker_drill", Loc[Config.Lan].info["cracking_stone"], math.random(1500,2500), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				TriggerServerEvent('op-mining:CrackReward')
				IsDrilling = false
				TriggerEvent("op-mining:CheckHasStone")
			end, function() -- Cancel
				StopAnimTask(GetPlayerPed(-1), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
				cracking = false
			end)
			Wait(5000)
		end
		Wait(1000)
	end
end)

-- I'm proud of this whole trigger command here
-- I was worried I'd have to do loads of call backs, back and forths in the this command
-- I had a theory that (like with notifications) I'd be able to add in a dynamic variable with the trigger being called
-- IT WORKED, and here we have it calling a item check callback via the ID it recieves from the menu buttons

RegisterNetEvent('op-mining:MakeItem', function(data)
	for k, v in pairs(data.craftable[data.tablenumber]) do
		QBCore.Functions.TriggerCallback('op-mining:get', function(amount) 
			if not amount then 
				TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_ingredients"], 'error')
				TriggerEvent('op-mining:SmeltMenu')
			else itemProgress(data.item, data.tablenumber, data.craftable) end		
		end, data.item, data.tablenumber, data.craftable)
	end
end)

RegisterNetEvent('op-mining:MakeItem:Cutting', function(data)
	QBCore.Functions.TriggerCallback("op-mining:Cutting:Check:Tools",function(hasTools)
		if hasTools then
			for k, v in pairs(data.craftable[data.tablenumber]) do
				QBCore.Functions.TriggerCallback('op-mining:get', function(amount) 
					if not amount then 
						TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_ingredients"], 'error')
					else 
						itemProgress(data.item, data.tablenumber, data.craftable)
					end		
				end, data.item, data.tablenumber, data.craftable)
			end
		else
			TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_drill_bit"], 'error')
			TriggerEvent('op-mining:JewelCut')
		end
	end)
end)

function itemProgress(ItemMake, tablenumber, craftable)
	if craftable then
		for i = 1, #Crafting.SmeltMenu do
			for k, v in pairs(Crafting.SmeltMenu[i]) do
				if ItemMake == k then
					bartext = Loc[Config.Lan].info["smelting"]..QBCore.Shared.Items[ItemMake].label
					bartime = 2000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
					openSmeltMenu = true
				end
			end
		end
		for i = 1, #Crafting.GemCut do
			for k, v in pairs(Crafting.GemCut[i]) do
				if ItemMake == k then
					bartext = Loc[Config.Lan].info["cutting"]..QBCore.Shared.Items[ItemMake].label
					bartime = 2000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
					openGemcut = true
				end
			end
		end
		for i = 1, #Crafting.RingCut do	
			for k, v in pairs(Crafting.RingCut[i]) do
				if ItemMake == k then
					bartext = Loc[Config.Lan].info["cutting"]..QBCore.Shared.Items[ItemMake].label
					bartime = 2000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
					openRingcut = true
				end
			end
		end
		for i = 1, #Crafting.NeckCut do
			for k, v in pairs(Crafting.NeckCut[i]) do
				if ItemMake == k then
					bartext = Loc[Config.Lan].info["cutting"]..QBCore.Shared.Items[ItemMake].label
					bartime = 2000
					animDictNow = "amb@prop_human_parking_meter@male@idle_a"
					animNow = "idle_a"
					openNeckcut = true
				end
			end
		end
	end
	QBCore.Functions.Progressbar('making_food', bartext, bartime, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = animDictNow,
		anim = animNow,
		flags = 8,
	}, {}, {}, function()  
		TriggerServerEvent('op-mining:GetItem', ItemMake, tablenumber, craftable)
		StopAnimTask(GetPlayerPed(-1), animDictNow, animNow, 1.0)
		if openNeckcut then
			TriggerEvent('op-mining:JewelCut:Necklace')
			openNeckcut = false
		elseif openRingcut then
			TriggerEvent('op-mining:JewelCut:Ring')
			openRingcut = false
		elseif openGemcut then
			TriggerEvent('op-mining:JewelCut:Gem')
			openGemcut = false
		elseif openSmeltMenu then
			TriggerEvent('op-mining:SmeltMenu')
			openSmeltMenu = false
		end
	end, function() -- Cancel
		TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["error.cancelled"], 'error')
	end)
end
------------------------------------------------------------
--These also lead to the actual selling commands

--Selling animations are simply a pass item to seller animation
--Sell Ore Animation
--Sell Anim small Test
RegisterNetEvent('op-mining:SellAnim', function(data)
	if data == -2 then
		exports['qb-menu']:closeMenu()
		return
	end
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('op-mining:Selling', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)		
			break
		end
	end
	TriggerEvent('op-mining:SellOre')
end)


--Sell Anim small Test
RegisterNetEvent('op-mining:SellAnim:Jewel', function(data)
	if data == -2 then
		exports['qb-menu']:closeMenu()
		return
	end	
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('op-mining:SellJewel', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)
			break
		end
	end	
	if string.find(data, "ring") then TriggerEvent('op-mining:JewelSell:Rings')
	elseif string.find(data, "chain") or string.find(data, "necklace") then TriggerEvent('op-mining:JewelSell:Necklace')
	elseif string.find(data, "emerald") then TriggerEvent('op-mining:JewelSell:Emerald')
	elseif string.find(data, "ruby") then TriggerEvent('op-mining:JewelSell:Ruby')
	elseif string.find(data, "diamond") then TriggerEvent('op-mining:JewelSell:Diamond')
	elseif string.find(data, "sapphire") then TriggerEvent('op-mining:JewelSell:Sapphire') end
end)


------------------------------------------------------------
--Context Menus
--Selling Ore
RegisterNetEvent('op-mining:SellOre', function()
	exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["header_oresell"], txt = Loc[Config.Lan].info["oresell_txt"], isMenuHeader = true },
		{ header = Loc[Config.Lan].info["copper_ore"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['copperore'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim", args = 'copperore' } },
		{ header = Loc[Config.Lan].info["iron_ore"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ironore'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim", args = 'ironore' } },
		{ header = Loc[Config.Lan].info["gold_ore"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['goldore'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim", args = 'goldore' } },
		{ header = Loc[Config.Lan].info["carbon"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['carbon'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim", args = 'carbon' } }, 
		{ header = "", txt = Loc[Config.Lan].info["close"], params = { event = "op-mining:SellAnim", args = -2 } },
	})
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('op-mining:JewelSell', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ header = Loc[Config.Lan].info["emeralds"], txt = Loc[Config.Lan].info["see_options"], params = { event = "op-mining:JewelSell:Emerald", } },
		{ header = Loc[Config.Lan].info["rubys"], txt = Loc[Config.Lan].info["see_options"], params = { event = "op-mining:JewelSell:Ruby", } },
		{ header = Loc[Config.Lan].info["diamonds"], txt = Loc[Config.Lan].info["see_options"], params = { event = "op-mining:JewelSell:Diamond", } },
		{ header = Loc[Config.Lan].info["sapphires"], txt = Loc[Config.Lan].info["see_options"], params = { event = "op-mining:JewelSell:Sapphire", } },
		{ header = Loc[Config.Lan].info["rings"], txt = Loc[Config.Lan].info["see_options"], params = { event = "op-mining:JewelSell:Rings", } },
		{ header = Loc[Config.Lan].info["necklaces"], txt = Loc[Config.Lan].info["see_options"], params = { event = "op-mining:JewelSell:Necklace", } },
		{ header = "", txt = Loc[Config.Lan].info["close"], params = { event = "op-mining:SellAnim:Jewel", args = -2 } },
	})
end)
--Jewel Selling - Emerald Menu
RegisterNetEvent('op-mining:JewelSell:Emerald', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ header = Loc[Config.Lan].info["emeralds"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'emerald' } },
		{ header = Loc[Config.Lan].info["uncut_emerald"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_emerald'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'uncut_emerald' } }, 
		{ header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelSell", } },
	})
end)
--Jewel Selling - Ruby Menu
RegisterNetEvent('op-mining:JewelSell:Ruby', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ header = Loc[Config.Lan].info["rubys"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'ruby' } },
		{ header = Loc[Config.Lan].info["uncut_ruby"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_ruby'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'uncut_ruby' } },
		{ header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelSell", } },
	})
end)
--Jewel Selling - Diamonds Menu
RegisterNetEvent('op-mining:JewelSell:Diamond', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ header = Loc[Config.Lan].info["diamonds"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'diamond' } },
		{ header = Loc[Config.Lan].info["uncut_diamond"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_diamond'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'uncut_diamond' } },
		{ header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelSell", } },
	})
end)
--Jewel Selling - Sapphire Menu
RegisterNetEvent('op-mining:JewelSell:Sapphire', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ header = Loc[Config.Lan].info["sapphires"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'sapphire' } },
		{ header = Loc[Config.Lan].info["uncut_sapphire"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['uncut_sapphire'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'uncut_sapphire' } },
		{ header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelSell", } },
	})
end)

--Jewel Selling - Jewellry Menu
RegisterNetEvent('op-mining:JewelSell:Rings', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ header = Loc[Config.Lan].info["gold_rings"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['gold_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'gold_ring' } },
		{ header = Loc[Config.Lan].info["diamond_rings"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'diamond_ring'} },
		{ header = Loc[Config.Lan].info["emerald_rings"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'emerald_ring' } },
		{ header = Loc[Config.Lan].info["ruby_rings"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'ruby_ring' } },	
		{ header = Loc[Config.Lan].info["sapphire_rings"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_ring'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'sapphire_ring' } },
		{ header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelSell", } },
	})
end)
--Jewel Selling - Jewellery Menu
RegisterNetEvent('op-mining:JewelSell:Necklace', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["jewel_buyer"], txt = Loc[Config.Lan].info["sell_jewel"], isMenuHeader = true }, 
		{ header = Loc[Config.Lan].info["gold_chains"],	txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['goldchain'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'goldchain' } },
		{ header = Loc[Config.Lan].info["10kgold_chain"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['10kgoldchain'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = '10kgoldchain' } },
		{ header = Loc[Config.Lan].info["diamond_neck"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['diamond_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'diamond_necklace' } },
		{ header = Loc[Config.Lan].info["emerald_neck"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['emerald_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'emerald_necklace' } },
		{ header = Loc[Config.Lan].info["ruby_neck"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['ruby_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'ruby_necklace' } },	
		{ header = Loc[Config.Lan].info["sapphire_neck"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['sapphire_necklace'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "op-mining:SellAnim:Jewel", args = 'sapphire_necklace' } },
		{ header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelSell", } },
	})
end)
------------------------

--Smelting
RegisterNetEvent('op-mining:SmeltMenu', function()
	local SmeltMenu = {}
	SmeltMenu[#SmeltMenu + 1] = { header = Loc[Config.Lan].info["smelter"], txt = Loc[Config.Lan].info["smelt_ores"], isMenuHeader = true }
	for i = 1, #Crafting.SmeltMenu do
		for k, v in pairs(Crafting.SmeltMenu[i]) do
			if k ~= "amount" then
				local text = ""
				if Crafting.SmeltMenu[i]["amount"] then amount = " x"..Crafting.SmeltMenu[i]["amount"] else amount = "" end
				setheader = QBCore.Shared.Items[k].label..tostring(amount)
				for l, b in pairs(Crafting.SmeltMenu[i][tostring(k)]) do
					if b == 1 then number = "" else number = " x"..b end
					text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
					settext = text
				end
				SmeltMenu[#SmeltMenu + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=15px> "..setheader, txt = settext, params = { event = "op-mining:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.SmeltMenu } } }
				settext, amount, setheader = nil
			end
		end
	end
	SmeltMenu[#SmeltMenu + 1] = { header = "", txt = Loc[Config.Lan].info["close"], params = { event = "op-mining:SellAnim", args = -2 } }
	exports['qb-menu']:openMenu(SmeltMenu)
end)
------------------------

--Cutting Jewels
RegisterNetEvent('op-mining:JewelCut', function()
    exports['qb-menu']:openMenu({
	{ header = Loc[Config.Lan].info["craft_bench"], txt = Loc[Config.Lan].info["req_drill_bit"], isMenuHeader = true },
	{ header = Loc[Config.Lan].info["gem_cut"],	txt = Loc[Config.Lan].info["gem_cut_section"], params = { event = "op-mining:JewelCut:Gem", } },
	{ header = Loc[Config.Lan].info["make_ring"], txt = Loc[Config.Lan].info["ring_craft_section"], params = { event = "op-mining:JewelCut:Ring", } },
	{ header = Loc[Config.Lan].info["make_neck"], txt = Loc[Config.Lan].info["neck_craft_section"], params = { event = "op-mining:JewelCut:Necklace", } },
	{ header = "", txt = Loc[Config.Lan].info["close"], params = { event = "op-mining:SellAnim", args = -2 } },
})
end)

--Gem Section
RegisterNetEvent('op-mining:JewelCut:Gem', function()
	local GemCut = {}
	GemCut[#GemCut + 1] = { header = Loc[Config.Lan].info["craft_bench"], txt = Loc[Config.Lan].info["req_drill_bit"], isMenuHeader = true }
	for i = 1, #Crafting.GemCut do
		for k, v in pairs(Crafting.GemCut[i]) do
			if k ~= "amount" then
				local text = ""
				if Crafting.GemCut[i]["amount"] then amount = " x"..Crafting.GemCut[i]["amount"] else amount = "" end
				setheader = QBCore.Shared.Items[k].label..tostring(amount)
				for l, b in pairs(Crafting.GemCut[i][tostring(k)]) do
					if b == 1 then number = "" else number = " x"..b end
					text = text.."- Requires: "..QBCore.Shared.Items[l].label..number.."<br>"
					settext = text
				end
				GemCut[#GemCut + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=15px>  "..setheader, txt = settext, params = { event = "op-mining:MakeItem:Cutting", args = { item = k, tablenumber = i, craftable = Crafting.GemCut } } }
				settext, setheader = nil
			end
		end
	end
	GemCut[#GemCut + 1] = { header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelCut", } }
	exports['qb-menu']:openMenu(GemCut)
end)

-- Ring Section
RegisterNetEvent('op-mining:JewelCut:Ring', function()
	local RingCut = {}
	RingCut[#RingCut + 1] = { header = Loc[Config.Lan].info["craft_bench"], txt = Loc[Config.Lan].info["req_drill_bit"], isMenuHeader = true }
	for i = 1, #Crafting.RingCut do
		for k, v in pairs(Crafting.RingCut[i]) do
			if k ~= "amount" then
				local text = ""
				if Crafting.RingCut[i]["amount"] then amount = " x"..Crafting.RingCut[i]["amount"] else amount = "" end
				setheader = QBCore.Shared.Items[k].label..tostring(amount)
				for l, b in pairs(Crafting.RingCut[i][tostring(k)]) do
					if b == 1 then number = "" else number = " x"..b end
					text = text.."- Requires: "..QBCore.Shared.Items[l].label..number.."<br>"
					settext = text
				end
				RingCut[#RingCut + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=15px>"..setheader, txt = settext, params = { event = "op-mining:MakeItem:Cutting", args = { item = k, tablenumber = i, craftable = Crafting.RingCut } } }
				settext, setheader = nil
			end
		end
	end
	RingCut[#RingCut + 1] = { header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelCut", } }
	exports['qb-menu']:openMenu(RingCut)
end)

--Necklace Section
RegisterNetEvent('op-mining:JewelCut:Necklace', function()
	local NeckCut = {}
	NeckCut[#NeckCut + 1] = { header = Loc[Config.Lan].info["craft_bench"], txt = Loc[Config.Lan].info["req_drill_bit"], isMenuHeader = true }
	for i = 1, #Crafting.NeckCut do
		for k, v in pairs(Crafting.NeckCut[i]) do
			if k ~= "amount" then
				local text = ""
				if Crafting.NeckCut[i]["amount"] then amount = " x"..Crafting.NeckCut[i]["amount"] else amount = "" end
				setheader = QBCore.Shared.Items[k].label..tostring(amount)
				for l, b in pairs(Crafting.NeckCut[i][tostring(k)]) do
					if b == 1 then number = "" else number = " x"..b end
					text = text.."- Requires: "..QBCore.Shared.Items[l].label..number.."<br>"
					settext = text
				end
				NeckCut[#NeckCut + 1] = { header = "<img src=nui://"..Config.ImageLink..QBCore.Shared.Items[k].image.." width=15px>"..setheader, txt = settext, params = { event = "op-mining:MakeItem:Cutting", args = { item = k, tablenumber = i, craftable = Crafting.NeckCut } } }
				settext, setheader = nil
			end
		end
	end
	NeckCut[#NeckCut + 1] = { header = "", txt = Loc[Config.Lan].info["return"], params = { event = "op-mining:JewelCut", } }
	exports['qb-menu']:openMenu(NeckCut)
end)