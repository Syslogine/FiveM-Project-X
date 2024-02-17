


function DrawText3DTest(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.31, 0.31)
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

RegisterCommand("oktest" ,function()
  TriggerEvent("cas:open1")



end)

RegisterNetEvent("cas:open1")
AddEventHandler("cas:open1" ,function()

  local ethica = exports["isPed"]:GroupRank("casino")
  if ethica > 0 then     
    print("work")

    TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
    Citizen.Wait(900)
    TriggerEvent("server-inventory-open", "1", "cas")
  else
    TriggerEvent('DoLongHudText', 'You do not work here', 2)
  end


end)


RegisterNetEvent("cas:open2")
AddEventHandler("cas:open2" ,function()

  local ethica = exports["isPed"]:GroupRank("casino")
  if ethica > 0 then     
    print("work")

    TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
    Citizen.Wait(900)
    TriggerEvent("server-inventory-open", "1", "cas2")
  else
    TriggerEvent('DoLongHudText', 'You are not a VIP broke bitch', 2)
  end


end)



Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if (GetDistanceBetweenCoords(pos, 1089.82 , 221.15 , -49.2, true) < 5) then
      DrawMarker(2,1089.82 , 221.15 , -49.2 , 0.0, 0.0, 0.0, 300.0, 0.0, 0.0, 0.25, 0.25, 0.05, 0, 100, 255, 255, false, true, 2, false, false, false, false)
      DrawText3DTest(1089.82 , 221.15 , -49.2 + 0.2, "~b~[E]~w~ Open Storage")
      if IsControlJustReleased(1, 38) then        
        TriggerEvent("cas:open1")

      end
    
    end 

  end

end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if (GetDistanceBetweenCoords(pos, 1114.53 , 248.04 , -45.84, true) < 5) then
      DrawMarker(2,1114.53 , 248.04 , -45.84 , 0.0, 0.0, 0.0, 300.0, 0.0, 0.0, 0.25, 0.25, 0.05, 0, 100, 255, 255, false, true, 2, false, false, false, false)
      DrawText3DTest(1114.53 , 248.04 , -45.84 + 0.2, "~b~[E]~w~ Open Storage")
      if IsControlJustReleased(1, 38) then        
        TriggerEvent("cas:open2")

      end
    
    end 

  end

end)



RegisterNetEvent("tp:castp")
AddEventHandler("tp:castp" ,function()
  if exports["ethical-inventory"]:hasEnoughOfItem("galleryvip",1) then
    local Getmecuh = PlayerPedId()
    TriggerEvent('dooranim')
    TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
    DoScreenFadeOut(400)
    Citizen.Wait(500)
    SetEntityCoords(Getmecuh, 982.63, 54.15, 116.16)
    Citizen.Wait(500)
    DoScreenFadeIn(500)

  else
    TriggerEvent("DoLongHudText","You are not a VIP broke bitch",2)

  end

end)

RegisterNetEvent("tp:castp2")
AddEventHandler("tp:castp2" ,function()
  if exports["ethical-inventory"]:hasEnoughOfItem("galleryvip",1) then
  local Getmecuh = PlayerPedId()
  TriggerEvent('dooranim')
  TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
  DoScreenFadeOut(400)
  Citizen.Wait(500)
  SetEntityCoords(Getmecuh, 964.09, 58.14, 112.55)
  Citizen.Wait(500)
  DoScreenFadeIn(500)
else
  TriggerEvent("DoLongHudText","You are not a VIP broke bitch",2)

end

end)


RegisterNetEvent("tp:back")
AddEventHandler("tp:back" ,function()
  local Getmecuh = PlayerPedId()
  TriggerEvent('dooranim')
  TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
  DoScreenFadeOut(400)
  Citizen.Wait(500)
  SetEntityCoords(Getmecuh, 1086.27, 213.63, -49.2)
  Citizen.Wait(500)
  DoScreenFadeIn(500)
end)






Citizen.CreateThread(function()
  Citizen.Wait(10)
  exports["ethical-polyzone"]:AddBoxZone("cas_zone", vector3(1089.82, 221.15, -49.2), 2.95, 0.8, {
    heading=271,
    minZ=36.99,
    maxZ=40.59
  })
  exports["ethical-polyzone"]:AddBoxZone("cas_zone", vector3(1114.53, 248.04, -45.84), 2.95, 0.8, {
    heading=70,
    minZ=28.32,
    maxZ=31.72
  })
end)





AddEventHandler("ethical-polyzone:enter", function(zone)
  if zone ~= "cas_zone" then return end
  exports["ethical-interaction"]:showInteraction("[E] Use Bank")
  -- listenForKeypress()
  Citizen.CreateThread(function()
    Citizen.Wait(2000)
    exports["ethical-interaction"]:hideInteraction()
  end)
end)

AddEventHandler("ethical-polyzone:exit", function(zone)
  if zone ~= "cas_zone" then return end
    exports["ethical-interaction"]:hideInteraction()
    listening = false
end)
