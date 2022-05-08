local QBCore = exports["qb-core"]:GetCoreObject()

RegisterServerEvent('op-oxy:server:startOxyRun')
AddEventHandler('op-oxy:server:startOxyRun', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)

	if Player.PlayerData.money["cash"] >= Config.StartPayment then
		Player.Functions.AddItem("oxy", amount)
		TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["oxy"], 'add')
		Player.Functions.RemoveMoney('cash', Config.StartPayment)
		TriggerClientEvent("op-oxy:client:startDealing", source)
	else
		TriggerClientEvent('QBCore:Notify', source, "You don't have enough money to start an oxy run")
	end
end)

RegisterServerEvent('op-oxy:server:deliverOxy')
AddEventHandler('op-oxy:server:deliverOxy', function(amount)
	local Player = QBCore.Functions.GetPlayer(source)
	Player.Functions.AddMoney('cash', amount)
	Player.Functions.RemoveItem("oxy", 1)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["oxy"], 'remove')
end)

RegisterServerEvent("op-oxy:server:getDebtBack")
AddEventHandler("op-oxy:server:getDebtBack", function(amount)
	local Player = QBCore.Functions.GetPlayer(source)
	Player.Functions.AddMoney("cash", amount)
end)

RegisterServerEvent("op-oxy:server:removeRemainingOxy")
AddEventHandler("op-oxy:server:removeRemainingOxy", function(amount)
	local Player = QBCore.Functions.GetPlayer(source)
	Player.Functions.RemoveItem("oxy", amount)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["oxy"], 'remove')
end)