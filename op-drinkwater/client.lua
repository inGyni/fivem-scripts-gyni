local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.Models, {
        options = {
            {
                type = "client",
                event = "op-drinkwater:client:drink",
                icon = "fa-solid fa-hand-holding-droplet",
                label = "Drink Water",
            }
        },
        distance = 2.0
    })
end)

RegisterNetEvent('op-drinkwater:client:drink', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
    QBCore.Functions.Progressbar("drink_something", "Drinking..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + math.random(35, 54))
    end)
end)