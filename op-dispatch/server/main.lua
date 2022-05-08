local QBCore = exports["qb-core"]:GetCoreObject()

local calls = 0

function isAuth(job)
    for i = 1, #Config["AuthorizedJobs"] do
        if job == Config["AuthorizedJobs"][i] then
            return true
        end
    end
    return false
end

RegisterServerEvent("dispatch:svNotify", function(data)
    calls = calls + 1
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent('dispatch:clNotify', xPlayer.PlayerData.source, data, calls)
        end
    end 
end)

RegisterServerEvent("op-dispatch:bankrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "bankrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:storerobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "storerobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:houserobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "houserobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:jewelrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "jewelrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:jailbreak", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "jailbreak", coords)
        end
    end
end)
RegisterServerEvent("op-dispatch:carjacking", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "carjacking", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:gunshot", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "gunshot", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:officerdown", function(coords)
for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "officerdown", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:casinorobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "casinorobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:drugsell", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "drugsell", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:atmrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "atmrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:civdown", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "civdown", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:artrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "artrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:humanerobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "humanerobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:trainrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "trainrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:vanrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "vanrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:undergroundrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "undergroundrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:drugboatrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "drugboatrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:unionrobbery", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "unionrobbery", coords)
        end
    end
end)

RegisterServerEvent("op-dispatch:911call", function(coords)
    for idx, id in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(id)
        if isAuth(xPlayer.PlayerData.job.name) then
            TriggerClientEvent("op-dispatch:createBlip", xPlayer.PlayerData.source, "911call", coords)
        end
    end
end)
