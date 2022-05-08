local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
	Wait(10)
	exports['qb-target']:AddTargetModel(Config.Models, {
    options = {
        {
            type = "client",
            event = "op-vending:client:openVendingMenu",
            icon = "fa-solid fa-glass-water",
            label = "Use vending machine",
        },
    },
    distance = 2.0
})
end)


RegisterNetEvent('op-vending:client:openVendingMenu', function()
    local menuItems = {
        {
            header = "Vending Machine",
            isMenuHeader = true,
        }
    }
    for k, v in pairs(Config.Items) do
        menuItems[#menuItems+1] = {
            header = v.name,
            txt = "Price: $" .. tostring(v.price),
            params = {
                event = "op-vending:client:buyItem",
                args = {
                    item = v.id,
                    price = v.price,
                    name = v.name,
                }
            }
        }
    end
    menuItems[#menuItems+1] = {
        header = "< Exit",
        txt = "",
        params = {
            event = "op-vending:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(menuItems)
end)

RegisterNetEvent("op-vending:client:closeMenu", function()
    exports['qb-menu']:closeMenu()
end)

RegisterNetEvent('op-vending:client:buyItem', function(data)
    Wait(100)
    if data.item ~= nil and data.price ~= nil then
        Wait(100)
        local ped = PlayerPedId()
        RequestAmbientAudioBank("VENDING_MACHINE", 0)
        local animDict = "mini@sprunk"
        if not HasAnimDictLoaded(animDict) then
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Wait(10)
            end
        end
        TaskPlayAnim(ped, animDict, "PLYR_BUY_DRINK_PT1", 4.0, -1000.0, -1, 0x100000, 0.0, 0, 2052, 0)
        QBCore.Functions.Progressbar("use_vending", "Buying a " .. data.name .. "...", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            ClearPedTasks(PlayerPedId())
            if QBCore.Functions.GetPlayerData().money['cash'] >= data.price then
                TriggerServerEvent("op-vending:server:buyItem", data.item, data.price)
                QBCore.Functions.Notify("You bought a " .. data.name .. ".", "success", 3500)
            else
                QBCore.Functions.Notify("You don't have enough cash!", 'error', 3500)
            end
        end)
    end
end)
