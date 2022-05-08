local QBCore = exports['qb-core']:GetCoreObject()

local lastAnimals = {}
local animals = {
    {model = "a_c_deer", hash = -664053099, item = "meatdeer", id = 35},
    {model = "a_c_pig", hash = -1323586730, item = "meatpig", id = 36},
    {model = "a_c_boar", hash = -832573324, item = "meatboar", id = 37},
    {model = "a_c_mtlion", hash = 307287994, item = "meatlion",id = 38},
    {model = "a_c_cow", hash = -50684386, item = "meatcow", id = 39},
    {model = "a_c_coyote", hash = 1682622302, item = "meatcoyote", id = 40},
    {model = "a_c_rabbit_01", hash = -541762431, item = "meatrabbit", id = 41},
    {model = "a_c_pigeon", hash = 111281960, item = "meatbird", id = 42},
    {model = "a_c_seagull", hash = -745300483, item = "meatseagull", id = 43},
	{model = "a_c_cormorant", hash = 1457690978, item = "meatcormorant", id = 44},
	{model = "a_c_chickenhawk", hash = -1430839454, item = "meatchickenhawk", id = 45},
	{model = "a_c_crow", hash = 402729631, item = "meatcrow", id = 46},
}

Citizen.CreateThread(function()
	local animalModels = {}
	for _, v in pairs(animals) do
		table.insert(animalModels, v.hash)
	end
	Citizen.Wait(100)
	exports['qb-target']:AddTargetModel(animalModels, {
        options = {
            {
                event = "op-hunting:client:skinanimal",
                icon = "fa-solid fa-utensils",
                label = "Cut Animal",
				entity = entity,
            },
        },
        job = { "hunter" },
        distance = 2.5
    })
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerGang = PlayerData.gang
    PlayerJob = PlayerData.job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerJob = job
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    PlayerGang = gang
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-679.15, 5839.5, 17.33)
	SetBlipSprite(blip, 141)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 37)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Hunting Store")
    EndTextCommandSetBlipName(blip)
end)


function getAnimalMatch(hash)
    for _, v in pairs(animals) do if (v.hash == hash) then return v end end
end

function removeEntity(entity)
    local delidx = 0

    for i = 1, #lastAnimals do
        if (lastAnimals[i].entity == entity) then delidx = i end
    end

    if (delidx > 0) then table.remove(lastAnimals, delidx) end
end

function lastAnimalExists(entity)
    for _, v in pairs(lastAnimals) do
        if (v.entity == entity) then return true end
    end
end

function handleDecorator(animal)
    if (DecorExistOn(animal, "lastshot")) then
        DecorSetInt(animal, "lastshot", GetPlayerServerId(PlayerId()))
    else
        DecorRegister("lastshot", 3)
        DecorSetInt(animal, "lastshot", GetPlayerServerId(PlayerId()))
    end
end

function isKillMine(animal)
    if (DecorExistOn(animal, "lastshot")) then
        local aid = DecorGetInt(animal, "lastshot")
        local id = GetPlayerServerId(PlayerId())

        return aid == id
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        Wait(1)
        if (IsAimCamActive()) and not IsPedInAnyVehicle(ped, false) then
            local _, ent = GetEntityPlayerIsFreeAimingAt(PlayerId(), Citizen.ReturnResultAnyway())
            if (ent and not IsEntityDead(ent)) then
                if (IsEntityAPed(ent)) then
                    local model = GetEntityModel(ent)
                    local animal = getAnimalMatch(model)
                    if (model and animal) then
                        handleDecorator(ent)
                        if (not lastAnimalExists(ent)) then
                            if (#lastAnimals > 5) then
                                table.remove(lastAnimals, 1)
                            end
                            local newAnim = {}
                            newAnim.entity = ent
                            newAnim.data = animal
                            table.insert(lastAnimals, newAnim)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("op-hunting:client:skinanimal", function()
    local ped = GetPlayerPed(-1)
	if (#lastAnimals > 0) then
        for _, v in pairs(lastAnimals) do
			if isKillMine(v.entity) then
				if (DoesEntityExist(v.entity)) then
					if (IsEntityDead(v.entity)) then
						if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_KNIFE") then
							local random = math.random(5, 10)
							loadAnimDict('amb@medic@standing@kneel@base')
							loadAnimDict('anim@gangops@facility@servers@bodysearch@')
							TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
							TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0, false, false, false)
							QBCore.Functions.Progressbar('apanhar_animal', 'Cutting Animal...', 5000, false, true, {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							}, {}, {}, {}, function()
								ClearPedTasks(GetPlayerPed(-1))
								TriggerServerEvent('op-hunting:server:AddItem', v.data.id, random)
								Citizen.Wait(1500)
								removeEntity(v.entity)
								DeleteEntity(v.entity)
							end)
						else
							QBCore.Functions.Notify("You need a knife to cut the animal!", "error", 3000)
						end
					end
				else
					removeEntity(v.entity)
					DeleteEntity(v.entity)
				end
			end
		end
	end
end)

RegisterNetEvent('op-hunting:client:BuyMusket')
AddEventHandler('op-hunting:client:BuyMusket', function(data)
    TriggerServerEvent('op-hunting:server:BuyMusket')
end)

RegisterNetEvent('op-hunting:client:BuyAmmo')
AddEventHandler('op-hunting:client:BuyAmmo', function(data)
    TriggerServerEvent('op-hunting:server:BuyAmmo')
end)

RegisterNetEvent('op-hunting:client:BuyKnife')
AddEventHandler('op-hunting:client:BuyKnife', function(data)
    TriggerServerEvent('op-hunting:server:BuyKnife')
end)

RegisterNetEvent('op-hunting:client:Sell')
AddEventHandler('op-hunting:client:Sell', function(data)
    TriggerServerEvent('op-hunting:server:Sell')
end)

RegisterNetEvent('op-hunting:client:OpenStore')
AddEventHandler('op-hunting:client:OpenStore', function()
    exports['qb-menu']:openMenu({
        {
            header = "Hunting shop",
            isMenuHeader = true,
        },
        {
            header = "Buy Musket Rifle",
            txt = "Price: 40000$",
            params = {
                event = "op-hunting:client:BuyMusket",
            }
        },
        {
            header = "Buy Shotgun Ammo",
            txt = "Price: 500$",
            params = {
                event = "op-hunting:client:BuyAmmo",
            }
        },
        {
            header = "Buy Knife",
            txt = "Price: 500$",
            params = {
                event = "op-hunting:client:BuyKnife",
            }
        },
        {
            header = "Sell Meat",
            txt = "Sell all the meat that you have.",
            params = {
                event = "op-hunting:client:Sell",
            }
        },
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    })
end)

------