local result = nil
local status = false

RegisterNetEvent('op-skillcheck:startSkillcheck')
AddEventHandler('op-skillcheck:startSkillcheck', function(callback, circles)
    skillcheckCallback = callback
    exports['op-skillcheck']:StartSkillCheck(total, circles)
end)

function StartSkillCheck(circles, seconds, callback)
    result = nil
    status = true
    SendNUIMessage({
        action = 'start',
        value = circles,
		time = seconds,
    })
    while status do
        Wait(5)
        SetNuiFocus(status, false)
    end
    Wait(100)
    SetNuiFocus(false, false)
    skillcheckCallback = callback
    return result
end

RegisterNUICallback('fail', function()
    ClearPedTasks(PlayerPedId())
    result = false
    Wait(100)
    status = false
end)

RegisterNUICallback('success', function()
	result = true
	Wait(100)
	status = false
    SetNuiFocus(false, false)
    return result
end)

exports("StartSkillCheck", StartSkillCheck)