local QBCore = exports['qb-core']:GetCoreObject()
local activeSlot = {}

QBCore.Functions.CreateCallback('op-slotmachines:server:isSeatUsed', function(source, cb, index)
	if activeSlot[index] ~= nil then
		if activeSlot[index].used then
			cb(true)
		else
			activeSlot[index].used = true
			cb(false)
		end
	else
		activeSlot[index] = {}
		activeSlot[index].used = true
		cb(false)
	end
end)

RegisterNetEvent('op-slotmachines:server:notUsing')
AddEventHandler('op-slotmachines:server:notUsing',function(index)
	if activeSlot[index] ~= nil then
		activeSlot[index].used = false
	end
end)

RegisterNetEvent("op-slotmachines:server:taskStartSlots")
AddEventHandler("op-slotmachines:server:taskStartSlots", function(index, data)
	local src = source
	local data = data
	local index = index
	print("tss1")
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local chips = xPlayer.Functions.GetItemByName('casinochips')
	if chips and chips.amount >= data.bet then
		print("tss2")
		if activeSlot[index] then
			xPlayer.RemoveItem(Config.ItemName, data.bet)
			local w = {a = math.random(1,16),b = math.random(1,16),c = math.random(1,16)}
			
			local rnd1 = math.random(1,100)
			local rnd2 = math.random(1,100)
			local rnd3 = math.random(1,100)
			
			if Config.Offset then
				if rnd1 > 70 then w.a = w.a + 0.5 end
				if rnd2 > 70 then w.b = w.b + 0.5 end
				if rnd3 > 70 then w.c = w.c + 0.5 end
			end
			
			TriggerClientEvent('op-slotmachines:client:startSpin', src, index, w)
			activeSlot[index].win = w
		end
	else
		TriggerClientEvent("op-slotmachines:client:notify", src, "You do not have enough Chips, you need at least " ..data.bet.. " to bet.")
	end
end)

RegisterNetEvent('op-slotmachines:server:slotsCheckWin')
AddEventHandler('op-slotmachines:server:slotsCheckWin',function(index, data, dt)
	if activeSlot[index] then
		if activeSlot[index].win then
			if activeSlot[index].win.a == data.a
			and activeSlot[index].win.b == data.b
			and activeSlot[index].win.c == data.c then
				CheckForWin(activeSlot[index].win, dt)
			end
		end
	end
end)

function CheckForWin(w, data)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	local a = Config.Wins[w.a]
	local b = Config.Wins[w.b]
	local c = Config.Wins[w.c]
	local total = 0
	if a == b and b == c and a == c then
		if Config.Mult[a] then
			total = data.bet*Config.Mult[a]
		end		
	elseif a == '6' and b == '6' then
		total = data.bet*5
	elseif a == '6' and c == '6' then
		total = data.bet*5
	elseif b == '6' and c == '6' then
		total = data.bet*5
		
	elseif a == '6' then
		total = data.bet*2
	elseif b == '6' then
		total = data.bet*2
	elseif c == '6' then
		total = data.bet*2
	end
	if total > 0 then
		TriggerClientEvent("op-slotmachines:client:notify", src, "You won " ..total.. " Chips!")
		xPlayer.AddItem(Config.ItemName, total)
	else
		TriggerClientEvent("op-slotmachines:client:notify", src, "You lost, better luck next time!")
	end
end