local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("op-vending:server:buyItem")
AddEventHandler("op-vending:server:buyItem", function(item, price)
	local player = QBCore.Functions.GetPlayer(source)
    player.Functions.RemoveMoney('cash', price)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add')
	player.Functions.AddItem(item, 1)
end)
