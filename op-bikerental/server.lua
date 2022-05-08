local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("op-bikerental:server:rentBike", function(price)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.RemoveMoney('cash', price, "rent-bike")
end)