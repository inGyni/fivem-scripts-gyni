local crouched = false
local crouchedForce = false
local aimed = false
local lastCam = 0

local function normalWalk()
	local Player = PlayerPedId()
	SetPedMaxMoveBlendRatio(Player, 1.0)
	ResetPedMovementClipset(Player, 0.55)
	ResetPedStrafeClipset(Player)
	SetPedCanPlayAmbientAnims(Player, true)
	SetPedCanPlayAmbientBaseAnims(Player, true)
	ResetPedWeaponMovementClipset(Player)
	crouched = false
end

local function canCrouch()
	local PlayerPed = PlayerPedId()
	if IsPedOnFoot(PlayerPed) and not IsPedJumping(PlayerPed) and not IsPedFalling(PlayerPed) and not IsPedDeadOrDying(PlayerPed) then
		return true
	else
		return false
	end
end

local function isPlayerFreeAimed()
	if IsPlayerFreeAiming(GetPlayerIndex()) or IsAimCamActive() or IsAimCamThirdPersonActive() then
		return true
	else
		return false
	end
end

local function crouchLoop()
    RequestAnimSet('move_ped_crouched')
    while not HasAnimSetLoaded('move_ped_crouched') do
        Wait(0)
    end
	while crouchedForce do
		local canDo = canCrouch()
		if canDo and crouched and isPlayerFreeAimed() then
			SetPedMaxMoveBlendRatio(PlayerPedId(), 0.2)
			aimed = true
		elseif canDo and (not crouched or aimed) then
			local Player = PlayerPedId()
			SetPedUsingActionMode(Player, false, -1, "DEFAULT_ACTION")
			SetPedMovementClipset(Player, 'move_ped_crouched', 0.55)
			SetPedStrafeClipset(Player, 'move_ped_crouched_strafing')
			SetWeaponAnimationOverride(Player, "Ballistic")
			crouched = true
			aimed = false
		elseif not canDo and crouched then
			crouchedForce = false
			normalWalk()
		end

		local nowCam = GetFollowPedCamViewMode()
		if canDo and crouched and nowCam == 4 then
			SetFollowPedCamViewMode(lastCam)
		elseif canDo and Crouched and nowCam ~= 4 then
			lastCam = nowCam
		end

		Citizen.Wait(5)
	end
	normalWalk()
	RemoveAnimDict('move_ped_crouched')
end


local cooldown = false
RegisterCommand('crouch', function()
	DisableControlAction(0, 36, true)
	if not cooldown then
		crouchedForce = not crouchedForce
		if crouchedForce then
			CreateThread(crouchLoop)
		end
		cooldown = true
		SetTimeout(500, function()
			cooldown = false
		end)
	end
end, false)

RegisterKeyMapping('crouch', 'Crouch', 'keyboard', 'LCONTROL')

local function IsCrouched()
	return crouched
end

exports("IsCrouched", IsCrouched)
