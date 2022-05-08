Citizen.CreateThread(function()
    for k, v in pairs (Config.Blips) do
		print("Added Blip: " .. Config.Blips[k].label)
        local blip = AddBlipForCoord(Config.Blips[k].coords)
        SetBlipSprite(blip, Config.Blips[k].sprite)
        SetBlipColour(blip, Config.Blips[k].colour)
        SetBlipScale(blip, Config.Blips[k].scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blips[k].label)
        EndTextCommandSetBlipName(blip)
    end
end)