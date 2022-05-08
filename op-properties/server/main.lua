local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("op-properties:server:Logout", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MyItems = Player.PlayerData.items
    MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', {json.encode(MyItems), Player.PlayerData.citizenid})
    QBCore.Player.Logout(src)
    TriggerClientEvent('qb-multicharacter:client:chooseChar', src)
end)

QBCore.Functions.CreateCallback("op-properties:server:GetProperties", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData
    MySQL.Async.fetchAll('SELECT * FROM player_properties WHERE license = ? AND citizenid = ?', {PlayerData.license, PlayerData.citizenid}, function(sqlresult) 
        if sqlresult then
            local data = {}
            for i=1, #sqlresult do
                data[#data+1] = {
                    propertyId = sqlresult[i].id,
                    propertyIndex = sqlresult[i].propertyIndex,
                }
            end
            cb(data)
		end
    end)
end)

QBCore.Functions.CreateCallback("op-properties:server:GetSafeMoney", function(source, cb, propertyId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData
    MySQL.Async.fetchAll('SELECT * FROM player_properties WHERE license = ? AND citizenid = ? AND id = ?', {PlayerData.license, PlayerData.citizenid, propertyId}, function(sqlresult) 
        if sqlresult then
            local data = { 
                illegalMoney = sqlresult[1]["illegalMoney"],
                legalMoney = sqlresult[1]["legalMoney"],
            }
            cb(data)
		end
    end)
end)

RegisterNetEvent("op-properties:server:SellProperty", function(source, propertyIndex, playerId)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local target = QBCore.Functions.GetPlayer(tonumber(playerid))

    if not target then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid Player Id Supplied', 'error')
        return
    end

    if #( GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target.PlayerData.source)) ) < 3 then
        local propertyPrice = Config.Properties[i].price
        local commission = round(propertyPrice * Config.SellerCommision)
        if target.PlayerData.money['bank'] >= propertyPrice then
            MySQL.Async.insert('INSERT INTO player_properties (license, citizenid, fullname, propertyIndex) VALUES (?, ?, ?, ?)', {
                target.PlayerData.license,
                target.PlayerData.citizenid,
                target.PlayerData.firstname .. " " .. target.PlayerData.lastname,
                propertyIndex,
            })
            target.Functions.RemoveMoney('bank', propertyPrice, 'property-bought')
            player.Functions.AddMoney('bank', commission)
            TriggerEvent('qb-bossmenu:server:addAccountMoney', player.PlayerData.job.name, propertyPrice - commission)
            TriggerClientEvent('QBCore:Notify', src, 'You earned $'.. string.gsub(commission, '^(-?%d+)(%d%d%d)', '%1,%2') .. ' in commission for selling a property.', 'success')
            TriggerClientEvent('QBCore:Notify', target.PlayerData.source, 'Congratulations on your new property!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'The customer does not have enough money', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'This customer is not close enough', 'error')
    end
end)

RegisterNetEvent("op-properties:server:depositMoney", function(amount, moneyType, orignalAmount, propertyId)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xMoneyType = moneyType == "illegal" and "illegal" or "cash"
    local playerMoney = xPlayer.PlayerData.money[xMoneyType]

    if playerMoney >= amount then
        xPlayer.Functions.RemoveMoney(xMoneyType, amount, 'deposit-house')
        MySQL.Async.execute('UPDATE player_properties SET ' .. moneyType .. 'Money' .. ' = ? WHERE id = ?', { orignalAmount + amount, propertyId })
        TriggerClientEvent('QBCore:Notify', src, "Successfully deposited " .. amount .. " into your safe.", 'success', 3500)
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have that money.", 'error', 3500)
    end
end)

RegisterNetEvent("op-properties:server:withdrawMoney", function(amount, moneyType, orignalAmount, propertyId)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local xMoneyType = moneyType == "illegal" and "illegal" or "cash"

    if orignalAmount >= amount then
        xPlayer.Functions.AddMoney(xMoneyType, amount, 'withdraw-house')
        MySQL.Async.execute('UPDATE player_properties SET ' .. moneyType .. 'Money' .. ' = ? WHERE id = ?', { orignalAmount - amount, propertyId })
        TriggerClientEvent('QBCore:Notify', src, "Successfully withdrew " .. amount .. " from your safe.", 'success', 3500)
    else
        TriggerClientEvent('QBCore:Notify', src, "Your safe doesn't have that money.", 'error', 3500)
    end
end)