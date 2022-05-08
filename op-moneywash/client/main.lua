local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

CreateThread(function()
	Wait(10)
	exports['qb-target']:AddTargetModel(Config.WashingMachineModels, {
    options = {
        {
            type = "client",
            event = "op-moneywash:client:washMoney",
            icon = "fa-solid fa-money-bill-wave",
            label = "Wash Illegal Money",
        },
    },
    distance = 2.5
})
end)

RegisterNetEvent("op-moneywash:client:washMoney", function(amount)
	local dialog = exports['qb-input']:ShowInput({
		header = "Wash illegal money",
		submitText = "Wash",
		inputs = {
			{
				text = "Amount to Wash",
				name = "amount",
				type = "number",
				isRequired = true,
			}
		}
	})
	if dialog then
		if not dialog.amount then return end
		TriggerServerEvent('op-moneywash:server:washMoney', tonumber(dialog.amount))
	end
end)