local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("op-arcade:server:buyTicket")
AddEventHandler("op-arcade:server:buyTicket", function(ticket)
    local src = source
    local data = Config.TicketPrices[ticket]
    local Player = QBCore.Functions.GetPlayer(source)
    local moneyPlayer = Player.PlayerData.money["cash"]
    if moneyPlayer > data.price then
        Player.Functions.RemoveMoney("cash", tonumber(data.price), "arcade-ticket")
        if Player.Functions.GetItemByName(ticket) then
            TriggerClientEvent('QBCore:Notify', source, data.name.." has been renewed!", "success")
            TriggerClientEvent("op-arcade:clientticketResult", source, ticket)
        else
            local info = {
                owner = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
                cardtime = Config.TicketPrices[ticket].time
            }
            Player.Functions.AddItem(ticket, 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ticket], "add", 1) 
            TriggerClientEvent("op-arcade:clientticketResult", source, ticket)
            TriggerClientEvent('QBCore:Notify', source, "You bought a "..data.name.." Play Card", "success")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "You dont have enough money!", "error")
    end
end)
