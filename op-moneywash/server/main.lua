local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('op-moneywash:server:washMoney')
AddEventHandler('op-moneywash:server:washMoney', function(amount)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local timetoWash = 15000

	if amount > 0 and xPlayer.PlayerData.money['illegal'] >= amount then
		xPlayer.Functions.RemoveMoney("illegal", amount, "washing-money")
		TriggerClientEvent("QBCore:Notify", src, "Washing $".. string.gsub(amount, "^(-?%d+)(%d%d%d)", '%1,%2') .. " illegal cash... Please wait.", "primary", timetoWash)
		Wait(timetoWash + 5000)
		
		TriggerClientEvent("QBCore:Notify", src, "You received a total of $" .. string.gsub(amount, "^(-?%d+)(%d%d%d)", '%1,%2') .. " in cash.", "success", 3500)
		xPlayer.Functions.AddMoney("cash", amount, "washed-money")
	else
		TriggerClientEvent("QBCore:Notify", src, "You don't have that money.", "error", 3500)
	end
end)