local QBCore = exports['qb-core']:GetCoreObject()
isLoggedIn = false
local onDuty = false
PlayerJob = {}

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "burgershot" then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
	onDuty = duty
end)

RegisterNetEvent("op-burgershot:DutyB")
AddEventHandler("op-burgershot:DutyB", function()
    TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent("op-burgershot:Tray1")
AddEventHandler("op-burgershot:Tray1", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgertray1")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgertray1", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("op-burgershot:Tray4")
AddEventHandler("op-burgershot:Tray4", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgertray4")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgertray4", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("op-burgershot:Tray3")
AddEventHandler("op-burgershot:Tray3", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgertray3")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgertray3", {
        maxweight = 10000,
        slots = 6,
    })
end)

RegisterNetEvent("op-burgershot:Storage")
AddEventHandler("op-burgershot:Storage", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgerstorage")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgerstorage", {
        maxweight = 250000,
        slots = 40,
    })
end)

RegisterNetEvent("op-burgershot:Storage2")
AddEventHandler("op-burgershot:Storage2", function()
    TriggerEvent("inventory:client:SetCurrentStash", "burgerstorage2")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgerstorage2", {
        maxweight = 250000,
        slots = 40,
    })
end)

--Meal Creations
RegisterNetEvent("op-burgershot:MurderMeal")
AddEventHandler("op-burgershot:MurderMeal", function()
		local randomToy = math.random(10,10)
		--remove box
		TriggerServerEvent('QBCore:Server:RemoveItem', "burger-murdermeal", 1)
		--add items from box
		TriggerServerEvent('QBCore:Server:AddItem', "burger-heartstopper", 1)
		TriggerServerEvent('QBCore:Server:AddItem', "burger-softdrink", 1)
		TriggerServerEvent('QBCore:Server:AddItem', "burger-fries", 1)

		if randomToy < 4 then
					TriggerServerEvent('QBCore:Server:AddItem', "bs_coupon-ten", 1)
					
		elseif randomToy == 4 then
					TriggerServerEvent('QBCore:Server:AddItem', "burger-toy1", 1)
            		
		elseif randomToy < 10 and randomToy > 4 then
					TriggerServerEvent('QBCore:Server:AddItem', "bs_coupon-fifteen", 1)
					
		elseif randomToy == 10 then
					TriggerServerEvent('QBCore:Server:AddItem', "burger-toy2", 1)
            		
		elseif randomToy > 10 and randomToy < 15 then
            		QBCore.Functions.Notify("No toy in Box Looool", "error")
		elseif randomToy == 15 then
					TriggerServerEvent('QBCore:Server:AddItem', "bs_coupon-25", 1)
            					
        end
end)

RegisterNetEvent("op-burgershot:CreateMurderMeal")
AddEventHandler("op-burgershot:CreateMurderMeal", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('op-burgershot:server:get:ingredientMurderMeal', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Making A Murder Meal..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-fries", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-heartstopper", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-softdrink", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-murdermeal", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-murdermeal"], "add")
                    QBCore.Functions.Notify("You made a A Murder Meal", "success")
				end, function()
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You dont have the items to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end  
end)

RegisterNetEvent("op-burgershot:BleederBurger")
AddEventHandler("op-burgershot:BleederBurger", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('op-burgershot:server:get:ingredientBurger', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Making Burgers..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-bleeder", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-bleeder"], "add")
                    QBCore.Functions.Notify("You made a Bleeder Burger", "success")
				end, function()
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end
end)

RegisterNetEvent("op-burgershot:MoneyShot")
AddEventHandler("op-burgershot:MoneyShot", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('op-burgershot:server:get:ingredientBurger', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Making Burgers..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-moneyshot", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-moneyshot"], "add")
                    QBCore.Functions.Notify("You made a MoneyShot Burger", "success")
				end, function()
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end
end)

RegisterNetEvent("op-burgershot:HeartStopper")
AddEventHandler("op-burgershot:HeartStopper", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('op-burgershot:server:get:ingredientBurger', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Making Burgers..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-heartstopper", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-heartstopper"], "add")
                    QBCore.Functions.Notify("You made a Heart Stopper", "success")
				end, function()
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end
end)


RegisterNetEvent("op-burgershot:Torpedo")
AddEventHandler("op-burgershot:Torpedo", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('op-burgershot:server:get:ingredientTorpedo', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Making A Torpedo..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-meat", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-torpedo", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-torpedo"], "add")
                    QBCore.Functions.Notify("You made a Torpedo Roll", "success")
				end, function()
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end  
end)

RegisterNetEvent("op-burgershot:MeatFree")
AddEventHandler("op-burgershot:MeatFree", function()
    if onDuty then
    	QBCore.Functions.TriggerCallback('op-burgershot:server:get:ingredientMeatfree', function(HasItems)  
    		if HasItems then
				QBCore.Functions.Progressbar("pickup_sla", "Making A Meat Free Burger..", 4000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_common",
					anim = "givetake1_a",
					flags = 8,
				}, {}, {}, function() -- Done
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-tomato", 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-lettuce", 1)
					TriggerServerEvent('QBCore:Server:RemoveItem', "burger-bun", 1)
					TriggerServerEvent('QBCore:Server:AddItem', "burger-meatfree", 1)
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-meatfree"], "add")
                	QBCore.Functions.Notify("You made a Meat Free Burger", "success")
				end, function()
					QBCore.Functions.Notify("Cancelled..", "error")
				end)
			else
   				QBCore.Functions.Notify("You dont have the ingredients to make this", "error")
			end
		end)
	else 
		QBCore.Functions.Notify("You must be Clocked into work", "error")
	end  
end)



RegisterNetEvent("op-burgershot:SoftDrink")
AddEventHandler("op-burgershot:SoftDrink", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakeSoftDrink()
        else
            QBCore.Functions.Notify("You don't have any soda syrup..", "error")
        end
      end, 'burger-sodasyrup')
    else
        QBCore.Functions.Notify("You must be Clocked into work", "error")
    end
end)

RegisterNetEvent("op-burgershot:mShake")
AddEventHandler("op-burgershot:mShake", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakeMShake()
        else
            QBCore.Functions.Notify("You don't have any Milkshake Formula..", "error")
        end
      end, 'burger-mshakeformula')
    else
        QBCore.Functions.Notify("You must be Clocked into work", "error")
    end
end)

RegisterNetEvent("op-burgershot:Fries")
AddEventHandler("op-burgershot:Fries", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakeFries()
        else
            QBCore.Functions.Notify("You don't have any potatoes..", "error")
        end
      end, 'burger-potato')
    else
        QBCore.Functions.Notify("You must be Clocked into work", "error")
    end
end)


RegisterNetEvent("op-burgershot:PattyFry")
AddEventHandler("op-burgershot:PattyFry", function()
    if onDuty then
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem then
           MakePatty()
        else
            QBCore.Functions.Notify("You don't have any raw patties..", "error")
        end
      end, 'burger-raw')
    else
        QBCore.Functions.Notify("You must be Clocked into work", "error")
    end
end)

-- Functions --
function MakeFries()
	TriggerServerEvent('QBCore:Server:RemoveItem', "burger-potato", 1)
	QBCore.Functions.Progressbar("pickup", "Frying the fries..", 4000, false, true, {
	    disableMovement = true,
	    disableCarMovement = true,
	    disableMouse = false,
	    disableCombat = true,
	},{
	    animDict = "amb@prop_human_bbq@male@base",
	    anim = "base",
	    flags = 8,
	    }, {
		model = "prop_cs_fork",
		bone = 28422,
		coords = vector3(-0.005, 0.00, 0.00),
		rotation = vector3(175.0, 160.0, 0.0),
	    }
	)
	Citizen.Wait(4000)
	TriggerServerEvent('QBCore:Server:AddItem', "burger-fries", 4)
	TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-fries"], "add")
	QBCore.Functions.Notify("You made 4 fries", "success")
	StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
end


function MakePatty()
    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-raw", 1)
    QBCore.Functions.Progressbar("pickup", "Cooking the Patty..", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    },{
        animDict = "amb@prop_human_bbq@male@base",
        anim = "base",
        flags = 8,
    }, {
        model = "prop_cs_fork",
        bone = 28422,
        coords = vector3(-0.005, 0.00, 0.00),
        rotation = vector3(175.0, 160.0, 0.0),
    }    
)
    Citizen.Wait(4000)
    TriggerServerEvent('QBCore:Server:AddItem', "burger-meat", 1)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-meat"], "add")
    QBCore.Functions.Notify("You cooked the meat", "success")
    StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
end

function MakeSoftDrink()
    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-sodasyrup", 1)
    QBCore.Functions.Progressbar("pickup", "Filling a cup..", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    })
    Citizen.Wait(4000)
    TriggerServerEvent('QBCore:Server:AddItem', "burger-softdrink", 1)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-softdrink"], "add")
    QBCore.Functions.Notify("You made a Soda", "success")
end  


function MakeMShake()
    TriggerServerEvent('QBCore:Server:RemoveItem', "burger-mshakeformula", 1)
    QBCore.Functions.Progressbar("pickup", "Filling up a cup..", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    })
    Citizen.Wait(4000)
    TriggerServerEvent('QBCore:Server:AddItem', "burger-mshake", 1)
    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["burger-mshake"], "add")
    QBCore.Functions.Notify("You made a Milkshake", "success")
end  
   
RegisterNetEvent("op-burgershot:shop")
AddEventHandler("op-burgershot:shop", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "burgershot", Config.Items)
end)