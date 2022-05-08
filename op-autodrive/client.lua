local QBCore = exports['qb-core']:GetCoreObject()
local isSelfDriving = false

Citizen.CreateThread(function()
    alert = false
    sensorstate = false
    local xPlayer = PlayerPedId()
    local y_key = 79
    reverse = false
    timer = 200
    sensor = 25
    posx = 0
    posy = 0
    ground = 0
    autodrive = false
    fposx = 0
    fposy = 0
    cruisespeed = 10
    camera = false
    display = false
    griddegree = 0
    while true do
		Citizen.Wait(100)
		if isSelfDriving then
			if IsPedInAnyVehicle(xPlayer, false) then        
				local veh = GetVehiclePedIsUsing(PlayerPedId())   
				local gear = GetEntitySpeedVector(veh,true)      
				local gear2 = GetVehicleCurrentGear(veh)         
				local retval, lights, highbeam = GetVehicleLightsState(veh)                                 
				if gear2 > 0 and gear.y >= 0 and reverse == false and autodrive == false then
					SetVehicleHandbrake(veh, false)  
					speed = (GetEntitySpeed(veh)* 2.236936)                                       
					local heading = GetEntityPhysicsHeading(veh)
					local wheelheading = GetVehicleWheelSteeringAngle(veh)*50
					local pos = GetEntityCoords(veh)

					posx = (4+(speed/10)*(speed/10)*0.4)*math.cos((heading+90+wheelheading)/57.5)
					posy = (4+(speed/10)*(speed/10)*0.4)*math.sin((heading+90+wheelheading)/57.5)
					fposx = 4*math.cos((heading+90+(wheelheading))/57.5)
					fposy = 4*math.sin((heading+90+(wheelheading))/57.5)   

					radarobject = getNearestVeh()
					radarveh = GetEntityCoords(radarobject)
					frontobject = getClosestVeh()
					frontveh = GetEntityCoords(frontobject)  
					
					radarobject2 = getNearestObj()
					radarveh2 = GetEntityCoords(radarobject2)
					frontobject2 = getClosestObj()
					frontveh2 = GetEntityCoords(frontobject2)  

					gr, ground = GetGroundZFor_3dCoord(pos.x + posx, pos.y + posy, pos.z+4, 0)
					distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, radarveh.x, radarveh.y, radarveh.z, false) 
					distance2 = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, radarveh2.x, radarveh2.y, radarveh2.z, false)                               
					if radarobject ~= 0 or radarobject2 ~= 0 then
						objectspeed = (GetEntitySpeed(radarobject)* 2.236936)      
						slowdistance = ((objectspeed*objectspeed)-(speed*speed))/(2*(distance)) 
						objectspeed2 = (GetEntitySpeed(radarobject2)* 2.236936)      
						slowdistance2 = ((objectspeed2*objectspeed2)-(speed*speed))/(2*(distance2))                     
						if speed > 10 and speed > objectspeed+20 and slowdistance < 0 and slowdistance*-1 >= distance+(distance/((speed-objectspeed)/10)) or speed > 10 and speed > objectspeed2+20 and slowdistance2 < 0 and slowdistance2*-1 >= distance2+(distance2/((speed-objectspeed2)/10)) then
							if speed > 0.8 then
								TaskVehicleTempAction(PlayerPedId(),veh,3,1) 
								SetVehicleBrake(veh, true)
								SetVehicleBrakeLights(veh, true)
							end
							SetVehicleBrake(veh, false)
							SetVehicleBrakeLights(veh, false)
							DisableControlAction(2,71,true)
							if alert == false then
								alert = true
								TriggerServerEvent('InteractSound_SV:PlayOnSource', 'error', 0.2)                          
							end                                                
						end                                     
					end
					if frontobject ~= 0 or frontobject2 ~= 0 then
						objectspeed = (GetEntitySpeed(frontobject)* 2.236936) 
						objectspeed2 = (GetEntitySpeed(frontobject2)* 2.236936)               
						if speed > objectspeed or speed > objectspeed2 then                        
							if speed > 0.8 then
								TaskVehicleTempAction(PlayerPedId(),veh,3,1) 
								SetVehicleBrake(veh, true)
								SetVehicleBrakeLights(veh, true)
							end
							SetVehicleBrake(veh, false)
							SetVehicleBrakeLights(veh, false)
							DisableControlAction(2,71,true)
						end                                     
					end  
				end                                                                 	                
				if reverse and autodrive == false then
					local pos = GetEntityCoords(veh)
					local heading = GetEntityPhysicsHeading(veh)
					local wheelheading = GetVehicleWheelSteeringAngle(veh)*20           
					local gear = GetVehicleCurrentGear(veh)        
					pitch = GetEntityPitch(veh)

					speed = (GetEntitySpeed(veh)* 2.236936) 
					rrobject4 = getRR4()
					rrobject3 = getRR3()
					rrobject2 = getRR2()
					rrobject1 = getRR1()

					fposx = math.cos((heading+270+wheelheading*-1)/57.5)
					fposy = math.sin((heading+270+wheelheading*-1)/57.5)                                              

					SetCamCoord(cam, pos.x + (2.6*math.cos((heading+272.25)/57.5)), pos.y + (2.6*math.sin((heading+272.25)/57.5)), pos.z-(pitch/25)+0.25)
					PointCamAtCoord(cam, pos.x + (5*math.cos((heading+272)/57.5)), pos.y + (5*math.sin((heading+272)/57.5)), pos.z-(pitch/10)-1)
					SetCamFov(cam, 100.0)    

					SetCamActive(cam, true)
					RenderScriptCams(true, true, 500, true, true)

					if rrobject4 ~= 0 then
						DisableControlAction(2,72,true)                
						if sensorstate == false then
							sensorstate = true
							sensor = 100
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'error', 0.2)                        
						end          
					end
					if rrobject1 ~= 0 and rrobject2 ~= 0 and rrobject3 ~= 0 and rrobject4 == 0 then                  
						if sensorstate == false then
							sensorstate = true
							sensor = 20
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'sensor', 0.2)                        
						end          
					end
					if rrobject1 ~= 0 and rrobject2 ~= 0 and rrobject3 == 0 then
						if sensorstate == false then
							sensorstate = true
							sensor = 22.5
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'sensor', 0.2)                      
						end                                     
					end
					if rrobject1 ~= 0 and rrobject2 == 0 and rrobject3 == 0 then
						if sensorstate == false then
							sensorstate = true                        
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'sensor', 0.2)                          
						end                                     
					end                

					SendInfo(GetVehicleWheelSteeringAngle(veh)*500)

					if gear == 1 and speed > 40 then
						SetCamActive(cam, false)
						RenderScriptCams(0, true, 500, true, true)
						reverse = false 
						SetDisplay(false)                   
					end
				end
				if alert then
					if timer > 0 then
						timer = timer - 1
					else
						alert = false
						timer = 200
					end
				end 
				if sensorstate then
					if sensor > 0 then
						sensor = sensor - 1
					else
						sensorstate = false
						sensor = 100
					end
				end 
				if IsControlJustReleased(1, 73) then                
					if reverse then
						reverse = false
						SetCamActive(cam, false)
						RenderScriptCams(0, true, 500, true, true)
						SetDisplay(false)
					else                
						reverse = true                    
						cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')                    
						SetDisplay(true)
					end            
				end
				if lights > 0 and highbeam < 1 and IsControlJustReleased(1, 74) then
					road = getRightSide()
					if road ~= 0 then
						reflector = GetEntityCoords(road)
						DisableControlAction(2,74,true)
						SendNotification({
							text = "The reflector would blind the oncoming traffic.",
							type = "success",
							timeout = 3000
						})
					end
				elseif lights > 0 and highbeam > 0 or lights > 0 and light2 and highbeam then
					road = getRightSide()                
					if road ~= 0 then
						SetVehicleLightMultiplier(veh, 0.3)
					else
						SetVehicleLightMultiplier(veh, 1.0)
					end          
				end
			end
		end
    end    
end)

function SetDisplay(bool)
    display = bool
    SendNUIMessage({
        type="ui",
        status = bool,
    })
end
function SendInfo(info)
    SendNUIMessage({
        type="angleinfo",
        angle = info,
    })
end

function getNearestVeh()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+speed/100, 1+speed/100, 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + posx, pos.y + posy, ground, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 10, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getClosestVeh()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+speed/100, 1+speed/100, 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + fposx, pos.y + fposy, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 10, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getNearestObj()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+(speed/100), 1+(speed/100), 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + posx, pos.y + posy, ground+1, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 2, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getClosestObj()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1+speed/100, 1+speed/100, 3.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + fposx, pos.y + fposy, pos.z+1, entityWorld.x, entityWorld.y, entityWorld.z, 1.0, 2, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end

function getRightSide()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 50.0, 50.0, 5.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + 7*fposx, pos.y + 7*fposy, ground, entityWorld.x, entityWorld.y, entityWorld.z, 50.0, 10, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end

function getRR4()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (1.8*fposx), pos.y + (1.8*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getRR3()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (3*fposx), pos.y + (3*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getRR2()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (4*fposx), pos.y + (4*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end
function getRR1()
    local veh = GetVehiclePedIsUsing(PlayerPedId()) 
    local pos = GetEntityCoords(veh)
            local entityWorld = GetOffsetFromEntityInWorldCoords(veh, 1.0, 1.0, 1.0)
    
            local rayHandle = StartShapeTestCapsule(pos.x + (5*fposx), pos.y + (5*fposy), pos.z-(pitch/25)+1, entityWorld.x, entityWorld.y, pos.z-(pitch/25)+1, 1.0, 1, veh, 7)
            local _, _, _, _, vehicleHandle = GetShapeTestResult(rayHandle)
    return vehicleHandle
end

local body = {
	scale = 0.3,
	offsetLine = 0.02,
	offsetX = 0.005,
	offsetY = 0.004,
	dict = 'commonmenu',
	sprite = 'gradient_bgd',
	width = 0.16,
	height = 0.012,
	heading = -90.0,
	gap = 0.002,
}

RequestStreamedTextureDict(body.dict)

local function goDown(v, id) 
	for i = 1, #v do
		if v[i].draw and i ~= id then
			v[i].y = v[i].y + (body.height + (v[id].lines*2 + 1)*body.offsetLine)/2 + body.gap
		end
	end
end

local function CountLines(v, text)
	BeginTextCommandLineCount("STRING")
    SetTextScale(body.scale, body.scale)
    SetTextWrap(v.x, v.x + body.width - body.offsetX)
	AddTextComponentSubstringPlayerName(text)
	local nbrLines = GetTextScreenLineCount(v.x + body.offsetX, v.y + body.offsetY)
	return nbrLines
end

local function DrawText(v, text)
	SetTextScale(body.scale, body.scale)
    SetTextWrap(v.x, v.x + body.width - body.offsetX)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(v.x + body.offsetX, v.y + body.offsetY)
end

local function DrawBackground(v)
	DrawSprite(body.dict, body.sprite, v.x + body.width/2, v.y + (body.height + v.lines*body.offsetLine)/2, body.width, body.height + v.lines*body.offsetLine, body.heading, 255, 255, 255, 255)
end

local positions = {
	['bottomLeft'] = { x = 0.160, y = 0.94, notif = {} },
}

function SendNotification(options)	
	QBCore.Functions.Notify(options.text, options.type, options.timeout)
end

function isVehWhitelisted()
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	local model = GetEntityModel(veh)
	local val = false
	for k, v in pairs(Config.WhitelistedCars) do
		if model == Config.WhitelistedCars[k].model then
			val = true
		end
	end
	
	if val ~= isSelfDriving then
		isSelfDriving = val
	end
end

Citizen.CreateThread(function()
    local xPlayer = PlayerPedId()
    local f2_key = 289
    local s_key = 72
    local w_key = 71
    local space = 76 
    local a_key = 63
    local d_key = 64
    local xpos = 0
    local ypos = 0
	local maxSpeed = 90
	local minSpeed = 5
    while true do
        Citizen.Wait(1)
        if IsPedInAnyVehicle(xPlayer, false) then            
            if IsControlJustReleased(1, f2_key) then
				isVehWhitelisted()
				if isSelfDriving then
					autodrive = not autodrive
					if autodrive then
						if IsWaypointActive() then
							local WaypointHandle = GetFirstBlipInfoId(8)                    
							x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())) 
							xpos = x
							ypos = y
							gr, ground = GetGroundZFor_3dCoord(x, y, z+1000, 0)        
							local veh = GetVehiclePedIsIn(PlayerPedId(), false)
							TaskVehicleDriveToCoord(xPlayer, veh, x, y, ground, 10.0, 1 | 2 | 4 | 8 | 16 | 32 | 128 | 256 | 1024 | 786603, 30.0, true)
							SetDriverAbility(PlayerPedId(), 100.0)
							SendNotification({
								text = "Selfdriving enabled.",
								type = "success",
								timeout = 3000
							})
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.2)
							autodrive = true
						else
							SendNotification({
								text = "No destination selected!",
								type = "error",
								timeout = 3000
							})
							isVehWhitelisted()
						end
					else
						ClearPedTasks(PlayerPedId())
						SendNotification({
							text = "Selfdriving disabled.",
							type = "success",
							timeout = 3000
						})
						TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.2) 
						autodrive = false
						isVehWhitelisted()
					end
				end
            end
            if autodrive then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)  
                local pos = GetEntityCoords(veh)               
                SetDriveTaskCruiseSpeed(PlayerPedId(),cruisespeed*2.236936)
                destinationlength = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, xpos, ypos, 30.0, false)
                if destinationlength < 30 then
					TaskVehicleTempAction(PlayerPedId(), veh, 27, 5000)
					SetVehicleBrake(veh, true)
					SetVehicleBrakeLights(veh, true)
                    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.2) 
                    ClearPedTasks(PlayerPedId())
                    autodrive = false
                    isSelfDriving = false
					SendNotification({
                        text = "Selfdriving disabled.",
						type = "success",
                        timeout = 3000
                    })
					Wait(1000)
					SetVehicleBrake(veh, false)
					SetVehicleBrakeLights(veh, false)
                end
                if IsControlJustReleased(1, 97) then
                    if cruisespeed > minSpeed then
                        cruisespeed = cruisespeed - 2.5
                    else
                        SendNotification({
                            text = "Minimum speed limit reached.",
							type = "success",
                            timeout = 3000
                        })
                    end
                elseif IsControlJustReleased(1, 96) then
                    if cruisespeed < maxSpeed then
                        cruisespeed = cruisespeed + 2.5
                    else
                        SendNotification({
                            text = "Maximum speed limit reached.",
							type = "success",
                            timeout = 3000
                        })
                    end
                end
            end
        end        
    end
end)
