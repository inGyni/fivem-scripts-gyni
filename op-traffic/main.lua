Citizen.CreateThread(function()
	for i = 1, 13 do
		EnableDispatchService(i, false)
	end
	while true do
		SetVehicleDensityMultiplierThisFrame(0.2)
		SetPedDensityMultiplierThisFrame(0.8)
		SetRandomVehicleDensityMultiplierThisFrame(0.2)
		SetParkedVehicleDensityMultiplierThisFrame(0.2)
		SetScenarioPedDensityMultiplierThisFrame(0.2, 0.2)
		SetRandomBoats(false)
		SetRandomTrains(false)
        SetGarbageTrucks(false)
		Citizen.Wait(0)
	end
end)
