local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('grantjob', "Grant Whitelisted job to a player (Admin Only)", {{name='Session ID', help='The target player session id'}, {name='Job', help='Valid Whitelist job'}, {name='Grade', help='Job Grade'}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = QBCore.Functions.GetPlayer(source)
    local job = args[2]
    local grade = args[3]
    if targetPlayer ~= nil then
		TriggerClientEvent('chat:addMessage', targetPlayer.PlayerData.source, { args = { "SYSTEM", "You've been granted a new whitelisted job: " .. job }, color = 0, 200, 250 })
		TriggerClientEvent('chat:addMessage', source, { args = { "SYSTEM", "You have gived the whitelisted job: ".. job .. " to: " ..targetPlayer.PlayerData.citizenid }, color = 0, 200, 250 })
        MySQL.Async.insert('INSERT INTO player_whitelistedjobs (xcitizenid, xlicense, citizenid, license, job, grade) VALUES (?, ?, ?, ?, ?, ?)', {
            senderPlayer.PlayerData.citizenid,
            senderPlayer.PlayerData.license,
            targetPlayer.PlayerData.citizenid,
            targetPlayer.PlayerData.license,
            job,
            grade
        })
    else
        TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_online"), 'error')
    end
end, 'admin')

QBCore.Commands.Add('revokejob', "Revoke Whitelisted job for a player (Admin Only)", {{name='Session ID', help='The target player session id'}, {name='Job', help='Valid Whitelist job'}}, true, function(source, args)
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local job = args[2]
    if targetPlayer ~= nil then
		TriggerClientEvent('chat:addMessage', targetPlayer.PlayerData.source, { args = { "SYSTEM", "You've been revoked from the whitelisted job: " .. job }, color = 0, 200, 250 })
		TriggerClientEvent('chat:addMessage', source, { args = { "SYSTEM", "You have revoked the whitelisted job: ".. job .. " for: " ..targetPlayer.PlayerData.citizenid }, color = 0, 200, 250 })
        MySQL.Async.insert('DELETE FROM player_whitelistedjobs WHERE citizenid = ? AND license = ? AND job = ?', {
            targetPlayer.PlayerData.citizenid,
            targetPlayer.PlayerData.license,
            job,
        })
    else
        TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_online"), 'error')
    end
end, 'admin')