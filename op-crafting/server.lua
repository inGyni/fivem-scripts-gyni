local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("op-crafting:server:craft")
AddEventHandler("op-crafting:server:craft", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemInfo = Config.Craftables[data.item]
    local hasItems = true
    for k, v in pairs(itemInfo.requirements) do
        local item = Player.Functions.GetItemByName(v.item)
        if item == nil or item.amount < v.amount then
            hasItems = false
        end
    end

    if hasItems then
        TriggerClientEvent("op-crafting:client:crafting", src, itemInfo)
        Wait(itemInfo.time)
        for k, v in pairs (itemInfo.requirements) do
            Player.Functions.RemoveItem(v.item, v.amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.item], "remove")
        end
        Player.Functions.AddItem(itemInfo.item, itemInfo.amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemInfo.item], "add")
        TriggerClientEvent('QBCore:Notify', src, "You crafted a " .. itemInfo.name, "success", 3500)
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have the required items!", "error", 3500)
    end
end)