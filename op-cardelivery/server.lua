local QBCore = exports["qb-core"]:GetCoreObject()

RegisterNetEvent("op-cardelivery:server:AddMoney")
AddEventHandler("op-cardelivery:server:AddMoney", function(amount)
	local Player = QBCore.Functions.GetPlayer(source)
	Player.Functions.AddMoney("cash", amount)
end)