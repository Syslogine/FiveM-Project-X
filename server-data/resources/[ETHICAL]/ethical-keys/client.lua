myKeys = {}
latestveh = nil
whatthefuckisthisdoing = 0

-- made by xerxes468893

local searchedVehicles = {}
local hotwiredVehicles = {}
local fuckingRETARDED = false

RegisterNetEvent('keys:addNew')
AddEventHandler('keys:addNew', function(vehicle, plate)
    if not vehicle then return end
    local vehiclePlate = plate or GetVehicleNumberPlateText(vehicle)
    if not myKeys[vehiclePlate] then
        myKeys[vehiclePlate] = true
    end
    SetVehRadioStation(vehicle, "OFF")
    SetVehicleDoorsLocked(vehicle, 1)
end)


RegisterNetEvent('garages:giveLoginKeys')
AddEventHandler("garages:giveLoginKeys", function(myDCKeys)
  for i = 1, #myDCKeys do
    if not hasKey(myDCKeys[i]) then
      table.insert(myKeys,myDCKeys[i])
    end

  end
end)

RegisterNetEvent('keys:loadKey')
AddEventHandler('keys:loadKey', function(plate)
  if plate == nil then
    return
  end
  if not hasKey(plate) then
    myKeys[#myKeys+1]= plate
  end
end)

RegisterNetEvent('keys:remove')
AddEventHandler('keys:remove', function(plate)
  if plate == nil then
    return
  end

  if hasKey(plate) then
    table.remove(myKeys, tablefind(myKeys, plate))
  end
end)

RegisterNetEvent('keys:reset')
AddEventHandler('keys:reset', function()
  myKeys = {}
  latestveh = nil
  whatthefuckisthisdoing = 0
  searchedVehicles = {}
  hotwiredVehicles = {}
  fuckingRETARDED = false
end)

RegisterNetEvent('keys:give')
AddEventHandler('keys:give', function()
  if #myKeys == 0 then
    TriggerEvent("DoLongHudText", "You have no keys to give!",2)
    return
  end

  local coordA = GetEntityCoords(PlayerPedId(), 1)
  local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
  local latestveh = getVehicleInDirection(coordA, coordB)




  if latestveh == nil or not DoesEntityExist(latestveh) then
    TriggerEvent("DoLongHudText", "Vehicle not found!",2)
    return
  end

  if not hasKey(GetVehicleNumberPlateText(latestveh)) then
      TriggerEvent("DoLongHudText", "No keys for target vehicle!",2)
      return
  end

  if #(GetEntityCoords(latestveh) - GetEntityCoords(PlayerPedId(), 0)) > 5 then
    TriggerEvent("DoLongHudText", "You are to far away from the vehicle!",2)
    return
  end

  t, distance = GetClosestPlayer()
  if(distance ~= -1 and distance < 5) then
    TriggerServerEvent('keys:send', GetPlayerServerId(t), GetVehicleNumberPlateText(latestveh))

    TriggerEvent("DoLongHudText", "You just gave keys to your vehicles!",1)
  else
    TriggerEvent("DoLongHudText", "No player near you!",2)
  end
end)

RegisterNetEvent('keys:gives')
AddEventHandler('keys:gives', function()
  if #myKeys == 0 then
    TriggerEvent("DoLongHudText", "You have no keys to give!",2)
    return
  end

  local player = PlayerPedId()
  local veh = GetVehiclePedIsIn(player, false)
  if veh == nil then
    TriggerEvent("DoLongHudText", "You are not in a car!",2)
    return
  end

  if not hasKey(GetVehicleNumberPlateText(veh)) then
      TriggerEvent("DoLongHudText", "No keys for target vehicle!",2)
      return
  end

  for i=-1, GetVehicleMaxNumberOfPassengers(veh)-1 do
    local ped = GetPedInVehicleSeat(veh, i)
    if ped ~= player then
      for j,v in pairs(GetActivePlayers()) do
        if GetPlayerPed(v) == ped then
          TriggerServerEvent('keys:send',GetPlayerServerId(v), GetVehicleNumberPlateText(veh))
          TriggerEvent("DoLongHudText", "You just gave keys to your vehicles!",1)
        end
      end
    end
  end
end)



RegisterNetEvent('keys:received')
AddEventHandler('keys:received', function(plate)
  if plate == nil then
    return
  end

  if not hasKey(plate) then
    myKeys[#myKeys+1]= plate
    TriggerEvent("DoLongHudText", "You just received keys to a vehicle!",1)
  else
    TriggerEvent("DoLongHudText", "You already have keys to that vehicle!",2)
  end
end)



RegisterNetEvent('keys:received2')
AddEventHandler('keys:received2', function(plate)
  if plate == nil then
    return
  end

  if not hasKey(plate) then
    myKeys[#myKeys+1]= plate


  end
end)




RegisterNetEvent('keys:checkandgive')
AddEventHandler('keys:checkandgive', function(newplate,oldplate)
  if hasKey(oldplate) then
    myKeys[#myKeys+1]= newplate
  end
end)



RegisterNetEvent("canItow")
AddEventHandler("canItow", function()

    coordA = GetEntityCoords(PlayerPedId(), 1)
    coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
        
    targetVehicle = getVehicleInDirection(coordA, coordB)
    if(targetVehicle ~= nil) then
       TriggerEvent('phone:assistRequest', 'tow', "Phone Call")
    else
      TriggerEvent("DoLongHudText","You must be facing the vehicle you want to tow.",2)
    end
end)

towavail = false

RegisterNetEvent('keys:hasKeys')
AddEventHandler('keys:hasKeys', function(from, veh)
  if veh == nil then
    if from == 'engine' then
        TriggerEvent("car:engineHasKeys", veh, false)
    elseif from == 'doors' then
        TriggerEvent("keys:unlockDoor", veh, false)
    end
    return
  end

  local plate = GetVehicleNumberPlateText(veh)
  local allow = hasKey(plate)

  if from == 'engine' then
      TriggerEvent("car:engineHasKeys", veh, allow)
  elseif from == 'doors' then
      TriggerEvent("keys:unlockDoor", veh, allow)
  end
end)


function getVehicleInDirection(coordFrom, coordTo)
  local offset = 0
  local rayHandle
  local vehicle

  for i = 0, 100 do
    rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0) 
    a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    
    offset = offset - 1

    if vehicle ~= 0 then break end
  end
  
  local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
  
  if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end


RegisterNetEvent('unseatPlayerCiv')
AddEventHandler('unseatPlayerCiv', function()
    local playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 20.0, 0.0)
        
    targetVehicle = getVehicleInDirection(coordA, coordB)
    if(targetVehicle ~= nil) then

      local plate = GetVehicleNumberPlateText(targetVehicle)
      local allow = hasKey(plate)

      t, distance = GetClosestPlayer()
      if(distance ~= -1 and distance < 10 and allow ) then
          TriggerServerEvent('unseatAccepted',GetPlayerServerId(t))
          TriggerEvent("DoLongHudText", 'Unseating',1)
      else
          TriggerEvent("DoLongHudText", 'No Player Found or you have No Keys',2)
      end

    else
        TriggerEvent("DoLongHudText", 'Car doesnt exist',2)
    end

end)


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


local deadzones = {
  [1] = { ["x"] = -43.59, ["y"] = -1099.08, ["z"] = 26.43, ["h"] = 107.89 },
  [2] = { ["x"] = -83.51,["y"] = 80.27,["z"] = 71.55,["h"] = 335.08 },
  [3] =  { ['x'] = -47.84,['y'] = -1682.12,['z'] = 29.45,['h'] = 311.95 },

}
RegisterNetEvent("vehsearch:disable")
AddEventHandler("vehsearch:disable", function(veh)
    searchedVehicles[veh] = true
end)

RegisterNetEvent('event:control:npkeys')
AddEventHandler('event:control:npkeys', function(useID)
    local playerped = PlayerPedId()      
    if IsPedInAnyVehicle(playerped, false) then
      local veh = GetVehiclePedIsUsing(playerped)
      local plate = GetVehicleNumberPlateText(veh)    
      if not searchedVehicles[veh] and not hasKey(plate) and GetPedInVehicleSeat(veh, -1) == playerped  then  
        if useID == 1 then
          Citizen.Wait(1000)
          TriggerEvent("ethical-dispatch:stealvehiclehoe")
          searchAndHotwireVehicle()
        elseif useID == 2 then
          Citizen.Wait(1000)
          attemptVehicleHotwire()
        end
      end
    end
end)

Controlkey = {["vehicleSearch"] = {47,"G"},["vehicleHotwire"] = {74,"H"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
  Controlkey["vehicleSearch"] = table["vehicleSearch"]
  Controlkey["vehicleHotwire"] = table["vehicleHotwire"]
end)


local disableF = false
Citizen.CreateThread( function()
  local latestveh = 0
  while true do
    Citizen.Wait(1)
    if disableF then
      DisableControlAction(0,23,true)
    end
    ----- IS IN VEHICLE -----
      local playerped = PlayerPedId()      
      if IsPedInAnyVehicle(playerped, false) then        
          ----- IS DRIVER -----
          local veh = GetVehiclePedIsUsing(playerped) 
          local plate = GetVehicleNumberPlateText(veh)
          if GetPedInVehicleSeat(veh, -1) == playerped then
              if (latestveh ~= veh) then
                TriggerEvent("tuner:setDriver")
              end
              if (latestveh ~= veh and not hasKey(plate)) or not hasKey(plate) then
                TriggerEvent("keys:shutoffengine")
              end

              if not searchedVehicles[veh] and not hasKey(plate) then
                if whatthefuckisthisdoing > 0 then
                  local d1 = #(vector3(deadzones[1]["x"], deadzones[1]["y"], deadzones[1]["z"]) - GetEntityCoords(PlayerPedId()))
                  local d2 = #(vector3(deadzones[2]["x"], deadzones[2]["y"], deadzones[2]["z"]) - GetEntityCoords(PlayerPedId()))
                  local d3 = #(vector3(deadzones[3]["x"], deadzones[3]["y"], deadzones[3]["z"]) - GetEntityCoords(PlayerPedId()))
                  if d1 > 10.0 and d2 > 10.0 and d2 > 25.0 then
                    local pos = GetOffsetFromEntityInWorldCoords(veh, 0.0, 2.0, 1.0)
                    DrawText3Ds(pos["x"],pos["y"],pos["z"], "["..Controlkey["vehicleSearch"][2].."] Search / ["..Controlkey["vehicleHotwire"][2].."] Hotwire" )
                    if IsControlJustPressed(0, 74) and GetLastInputMethod(2) then
   
                      TriggerEvent('event:control:npkeys', 2)
                    
                    elseif IsControlJustPressed(0, 58) and GetLastInputMethod(2) then
                      TriggerEvent('event:control:npkeys', 1)
                     
                    end
                  end
                end
              end

              latestveh = veh
          end
      else
        Wait(100)
      end
  end
end)



function DropItemFromVehicle()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    if vehicle == 0 then return end -- Simplified check for vehicle existence
    
    local randomChance = math.random(150)
    if randomChance <= 3 then
        SetVehicleDoorOpen(vehicle, 5, false, false) -- Trunk door index simplified
    else
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('vehicle:assignKeys', plate) -- Renamed for clarity
    end
end




function searchAndHotwireVehicle()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    -- Check if the vehicle has already been searched or if the player is not in a vehicle
    if not vehicle or searchedVehicles[vehicle] then return end
    
    -- Mark the vehicle as searched
    searchedVehicles[vehicle] = true

    -- Simulate the process of searching the vehicle or attempting to hotwire it
    local searchResult = exports["ethical-taskbar"]:taskBar(5000, "Searching Vehicle")
    -- Abort the process if the search/hotwire is not completed successfully or the player exits the vehicle
    if searchResult ~= 100 or not IsPedInAnyVehicle(PlayerPedId(), false) then return end

    -- Determine the outcome of the search/hotwire attempt
    if math.random(1, 10) == 5 then
        -- Player finds the keys
        exports["ethical-taskbar"]:taskBar(2000, "Found Keys")
        TriggerEvent("keys:addNew", vehicle, GetVehicleNumberPlateText(vehicle)) -- Add keys to the player's collection
        TriggerEvent("DoLongHudText", "You found the keys in the vehicle.", 1)
    else
        -- Attempting to hotwire the vehicle with a randomized chance of success
        local hotwireSuccess = exports["ethical-taskbar"]:taskBar(15000, "Attempting Hotwire")
        local successChance = math.random(50, 70)

        if successChance > 63 and hotwireSuccess == 100 then
            -- Hotwire is successful, but the vehicle doesn't automatically start
            TriggerEvent("keys:addNew", vehicle, GetVehicleNumberPlateText(vehicle)) -- Add keys as if hotwiring grants them
            TriggerEvent("DoLongHudText", "You successfully hotwired the vehicle.", 1)
        else
            -- Hotwire attempt failed
            TriggerEvent("DoLongHudText", "Hotwire attempt failed.", 2)
        end
    end

    -- Note: The vehicle engine does not automatically start here. Players can start it manually.

end

function attemptVehicleHotwire()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    if hotwiredVehicles[vehicle] or not vehicle then return end -- Early return if hotwired or no vehicle
    
    hotwiredVehicles[vehicle] = true
    TriggerEvent("animation:lockpickinvtest", true)
    TriggerEvent("keys:shutoffengine")

    local vehicleValue = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'nMonetaryValue')
    vehicleValue = math.clamp(vehicleValue, 45000, 120000) -- Using a hypothetical clamp function for clarity
    
    if exports["ethical-taskbar"]:taskBar(math.random(15000, vehicleValue), "Attempting Hotwire") == 100 and math.random(50, 70) > 63 then
        TriggerEvent("keys:addNew", vehicle, GetVehicleNumberPlateText(vehicle))
        TriggerEvent("DoLongHudText", "You successfully hotwired the vehicle.", 1)
    else
        TriggerEvent("DoLongHudText", "You cannot figure out this hotwire.", 2)
    end

    TriggerEvent("animation:lockpickinvtest", false)
end


function dolater()
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    local plate = GetVehicleNumberPlateText(veh)
    local model = GetEntityModel(veh)
    local otherped = GetPedInVehicleSeat(veh, -1)

    if PlayerPedId() ~= otherped then

      TaskVehicleDriveToCoord(GetPedInVehicleSeat(veh, -1), veh, 0.0,0.0,0.0, 40.0, 1074528293, model, 2883621, 0, -1)
      return
    end
end

RegisterNetEvent("timer:stolenvehicle")
AddEventHandler("timer:stolenvehicle", function(plate)
    Citizen.Wait(math.random(100))
    TriggerServerEvent("timer:addplate",plate)
end)

domsgnow = 0
Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)
        local doingsomething = false
        if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
          doingsomething = true
          local curveh = GetVehiclePedIsTryingToEnter(PlayerPedId())
          local plate1 = GetVehicleNumberPlateText(curveh)
          if not hasKey(plate1) then

            local pedDriver = GetPedInVehicleSeat(curveh, -1)
            if pedDriver ~= 0 and (not IsPedAPlayer(pedDriver) or IsEntityDead(pedDriver)) then


              if IsEntityDead(pedDriver) then

                TriggerEvent("ethical-dispatch:stealvehiclehoe")
                local finished = exports["ethical-taskbar"]:taskBar(3000,"Taking Keys",false)
                if finished == 100 then
                  TriggerEvent("keys:addNew",curveh,plate1)
                  TriggerEvent("timer:stolenvehicle",plate1)
                else
                  ClearPedTasksImmediately(PlayerPedId())
                end
              else

                if GetEntityModel(curveh) ~= 'taxi' then
                  
                  if math.random(100) > 95 then

                      TriggerEvent("ethical-dispatch:stealvehiclehoe")
                      local finished = exports["ethical-taskbar"]:taskBar(3000,"Taking Keys")
                      if finished == 100 then
                        TriggerEvent("keys:addNew",curveh,plate1)
                      else
                        ClearPedTasksImmediately(PlayerPedId())
                      end

                  else
                    SetVehicleDoorsLocked(curveh, 2)

                    Citizen.Wait(1000)
                    TriggerEvent("ethical-dispatch:stealvehiclehoe")
                    TaskReactAndFleePed(pedDriver, PlayerPedId())
                    SetPedKeepTask(pedDriver, true)
                    ClearPedTasksImmediately(PlayerPedId())
                    disableF = true
                    Citizen.Wait(2000)
                    disableF = false
                  end
                  
                else
                  TriggerEvent("startAITaxi",true)
                  
                  
                  SetPedIntoVehicle(PlayerPedId(), curveh, 2)
                  SetPedIntoVehicle(PlayerPedId(), curveh, 1)

                end
              end
            end
          end
        end

        if IsPedJacking(PlayerPedId()) then
          doingsomething = true
            local veh = GetVehiclePedIsUsing(PlayerPedId())
            local plate = GetVehicleNumberPlateText(veh)
            local stayhere = true

           while stayhere do

                local inCar = IsPedInAnyVehicle(PlayerPedId(), false)
                if not inCar then
                    stayhere = false
                end

                if IsVehicleEngineOn(veh) and not hasKey(plate) then
                    TriggerEvent("keys:shutoffengine")
                    stayhere = false
                end
                Citizen.Wait(1)
            end
        end   

        if domsgnow > 0 then
          domsgnow = domsgnow - 1
        end
        if not doingsomething then
          Wait(100)
        end
    end
end)

local bypass = false
local enforce = 0
local dele = 0

local function runningTick()
  local playerPed = PlayerPedId()
  local playerVehicle = GetVehiclePedIsUsing(playerPed)
  local isPlayerDriving = GetPedInVehicleSeat(playerVehicle, -1) == playerPed
  local plate = GetVehicleNumberPlateText(playerVehicle)

  if IsPedGettingIntoAVehicle(playerPed) then return 0 end

  if playerVehicle and isPlayerDriving then

    if IsControlJustReleased(1,96) and not IsThisModelAHeli(GetEntityModel(playerVehicle)) then
        TriggerEvent("car:engine")
  
    end
    
    CanShuffleSeat(playerPed, false)
    if (IsControlPressed(2, 75) or bypass) and IsVehicleDriveable(playerVehicle) then
      if enforce < 10 and hasKey(plate) then
        bypass = true
        SetVehicleEngineOn(playerVehicle, true, true)
        enforce = enforce + 1
        return 0
      end	

      if dele < 200 then
        dele = dele + 1
        return 0
      end

      if IsControlPressed(2, 75) and hasKey(plate) then
        SetVehicleEngineOn(playerVehicle, false, true)
      elseif IsVehicleDriveable(playerVehicle) then
        SetVehicleEngineOn(playerVehicle, true, true)
      end

      bypass = false
      dele = 0
      enforce = 0
    end
  else
    bypass = false
    dele = 0
    enforce = 0
    Wait(100)
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    runningTick()
  end
end)

RegisterNetEvent('keys:startvehicle')
AddEventHandler('keys:startvehicle', function()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    if vehicle and GetVehicleEngineHealth(vehicle) > 199 then
        SetVehicleEngineOn(vehicle, true, true, false)
        SetVehicleUndriveable(vehicle, false)
        if not Citizen.InvokeNative(0xAE31E7DF9B5B132E, vehicle) then
            SetVehicleEngineOn(vehicle, true, true, true)
        end
    else
        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleUndriveable(vehicle, true)
    end
end)

local isEngineShuttingOff = false

RegisterNetEvent('keys:shutoffengine')
AddEventHandler('keys:shutoffengine', function()
    if isEngineShuttingOff then
        return
    end
    isEngineShuttingOff = true
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    if vehicle then
        local countdown = 1000
        while countdown > 0 do
            Citizen.Wait(1)
            SetVehicleEngineOn(vehicle, false, true, true)
            countdown = countdown - 1
        end
    end
    isEngineShuttingOff = false
end)

function tablefind(tab,el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

function hasKey(plate)
  local has = false
    for _,v in pairs(myKeys) do
    if v ~= nil and v == plate then
        has = true
    end
  end
  return has
end
exports('hasKey', hasKey);

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

RegisterCommand("givekeys", function()
  TriggerEvent("keys:gives")
end)
