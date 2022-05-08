local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local attachedWeapons = {}
local currentWeapon = nil

Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		for i, weaponData in pairs(Config.AllowedWeapons) do
			Wait(100)
			if QBCore.Functions.HasItem(weaponData.name) and currentWeapon == nil then
				currentWeapon = weaponData.hash
				if not attachedWeapons[weaponData.prop] and GetSelectedPedWeapon(ped) ~= weaponData.hash then
					AttachWeapon(weaponData.prop, weaponData.hash, weaponData.name, Config.backBone, weaponData.position, weaponData.rotation, isMeleeWeapon(weaponData.prop))
				end
			end
		end
		for prop, attachedObject in pairs(attachedWeapons) do
			if GetSelectedPedWeapon(ped) == attachedObject.hash or not QBCore.Functions.HasItem(attachedWeapons.name) then
				DeleteObject(attachedObject.handle)
				attachedWeapons[prop] = nil
				currentWeapon = nil
			end
		end
		Wait(1000)
	end
end)

function AttachWeapon(dataProp, dataHash, dataName, backBone, pos, rot, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), backBone)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	local rx = rot.x
	local ry = rot.y
	local rz = rot.z
	RequestModel(dataProp)
	while not HasModelLoaded(dataProp) do
		Wait(100)
	end

	attachedWeapons[dataProp] = {
		hash = dataHash,
		handle = CreateObject(GetHashKey(dataProp), 1.0, 1.0, 1.0, true, true, false),
		name = dataName
	}

	if isMelee then 
		x = 0.11 
		y = -0.14 
		z = 0.0 
		rx = -75.0 
		ry = 185.0 
		rz = 92.0 
	end
	if dataProp == "prop_ld_jerrycan_01" then 
		x = x + 0.3
	end
	AttachEntityToEntity(attachedWeapons[dataProp].handle, GetPlayerPed(-1), bone, x, y, z, rx, ry, rz, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(prop)
	local meleeWeapon = false
    if prop == "prop_golf_iron_01" or prop == "w_me_bat" or prop == "prop_ld_jerrycan_01" then 
		meleeWeapon = true
    end
	return meleeWeapon
end
