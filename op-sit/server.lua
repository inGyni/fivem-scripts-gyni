local QBCore = exports['qb-core']:GetCoreObject()
local seatsTaken = {}

RegisterNetEvent('op-sit:server:sitDown', function(objectCoords)
	seatsTaken[objectCoords] = true
end)

RegisterNetEvent('op-sit:server:getUp', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end
end)

QBCore.Functions.CreateCallback('op-sit:server:isSeatTaken', function(source, cb, objectCoords)
	cb(seatsTaken[objectCoords])
end)
