local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-items:client:use:duffelbag', function(BagId)
    local player = PlayerPedId()
    if not clothingitem then
        QBCore.Functions.Progressbar("use_bag", "Opening on Bag", 1500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
    }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:UseDuffelBag", BagId)
			TriggerEvent("inventory:client:open")
        end)
    elseif clothingitem then
        clothingitem = false
        RequestAnimDict(dict)
        TaskPlayAnim(player, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 2500, 51, 0, false, false, false)
        Wait (600)
        ClearPedSecondaryTask(PlayerPedId())
        SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 2)
    end
    Wait(1500)
end)