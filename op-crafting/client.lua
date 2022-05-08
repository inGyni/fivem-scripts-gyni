local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

----------------------- INITIALIZING -----------------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = nil
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData = QBCore.Functions.GetPlayerData()
end)

----------------------- FUNCTIONS -----------------------

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    DrawRect(0.0, 0.0 + 0.0125, 0.017+ ((string.len(text)) / 370), 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent("op-crafting:client:crafting")
AddEventHandler("op-crafting:client:crafting", function(item)
    QBCore.Functions.Progressbar(item.info, "Crafting " .. item.name, item.time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_player",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        StopAnimTask(playerPed, dict, "machinic_loop_mechandplayer", 1.0)
        ClearPedTasks(playerPed)
    end)
end)

RegisterNetEvent('op-crafting:client:craftMenu', function(table)
    local craftingMenu = {
        {
            header = Config.CraftingTables[table].title,
            isMenuHeader = true,
        }
    }
    for item, v in ipairs(Config.Craftables) do
        if v.type == Config.CraftingTables[table].type then
            local text = "Requires: <br>"
            for b, requiredItems in pairs(v.requirements) do
                text = text .. requiredItems.label .. " x" .. requiredItems.amount .. "<br>"
            end
            craftingMenu[#craftingMenu + 1] = {
                header = v.title,
                txt = text,
                params = {
                    event = "op-crafting:server:craft",
                    isServer = true,
                    args = {
                        item = item
                    }
                },
            }
        end
    end
    craftingMenu[#craftingMenu + 1] = {
        header = "< Exit",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(craftingMenu)
end)

----------------------- THREADS -----------------------

local function checkAllowed(jobs, job)
    for i=1, #jobs do
        if job == jobs[i] then
            return false
        end
    end
    return true
end

Citizen.CreateThread(function()
    local nearestTable = nil
    local ped = PlayerPedId()
    while true do
        local pos = GetEntityCoords(ped)
        for i=1, #Config.CraftingTables do
            for v=1, #Config.CraftingTables[i].tables do
                if nearestTable == nil then
                    if #(pos - Config.CraftingTables[i].tables[v]) < Config.CraftingDistance then
                        nearestTable = v
                        break
                    end
                else
                    if #(pos - Config.CraftingTables[i].tables[nearestTable]) > Config.CraftingDistance then
                        nearestTable = nil
                        break
                    end
                end
                Wait(100)
            end
            if nearestTable ~= nil then
                if Config.CraftingTables[i].blacklistedJobs ~= nil and checkAllowed(Config.CraftingTables[i].blacklistedJobs, PlayerData.job.name) then
                    DrawText3D(Config.CraftingTables[i].tables[nearestTable].x, Config.CraftingTables[i].tables[nearestTable].y, Config.CraftingTables[i].tables[nearestTable].z, Config.CraftingTables[nearestTable].text) 
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("op-crafting:client:craftMenu", i)
                    end
                end
            end
        end
        Wait(0)
    end
end)