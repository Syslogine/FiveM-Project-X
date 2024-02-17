function Login.playerLoaded() end

function Login.characterLoaded()
  -- Main events leave alone 
  TriggerEvent("ethical-base:playerSpawned")
  TriggerEvent("playerSpawned")
  TriggerServerEvent('character:loadspawns')
  -- Main events leave alone 

  TriggerEvent("Relog")

  -- Everything that should trigger on character load 
  TriggerServerEvent('checkTypes')
  TriggerServerEvent('isVip')
  TriggerEvent('rehab:changeCharacter')
  TriggerEvent("resetinhouse")
  TriggerEvent("fx:clear")
  TriggerServerEvent('tattoos:retrieve')
  TriggerServerEvent('Blemishes:retrieve')
  TriggerServerEvent("currentconvictions")
  TriggerServerEvent("GarageData")
  TriggerServerEvent("Evidence:checkDna")
  TriggerEvent("banking:viewBalance")
  TriggerServerEvent("police:getLicensesCiv")
  TriggerServerEvent('ethical-doors:requestlatest')
  TriggerServerEvent("item:UpdateItemWeight")
  TriggerServerEvent("ethical-weapons:getAmmo")
  TriggerServerEvent("ReturnHouseKeys")
  TriggerServerEvent("requestOffices")
  Wait(500)
  TriggerServerEvent("Police:getMeta")
  -- Anything that might need to wait for the client to get information, do it here.
  Wait(3000)
  TriggerServerEvent("bones:server:requestServer")
  TriggerEvent("apart:GetItems")

  Wait(4000)
  TriggerServerEvent('distillery:getDistilleryLocation')
end

function Login.characterSpawned()
	SetEntityInvincible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent("attachWeapons")
	TriggerEvent("spawning",false)
	TriggerServerEvent('admin:getGroup')
	TriggerServerEvent('stocks:retrieve', exports['isPed']:isPed('cid'))
    TriggerServerEvent('server-inventory-request-identifier')
	TriggerServerEvent("server-request-update",exports["isPed"]:isPed("cid"))
	TriggerServerEvent('ethical-base:Licenses')
	TriggerServerEvent('ethical-base:updatedphoneLicenses')
	TriggerServerEvent("police:SetMeta")
	TriggerServerEvent('dispatch:setcallsign')
	Citizen.Wait(5000)
	SetEntityVisible(PlayerPedId(), true)
	FreezeEntityPosition(PlayerPedId(), false)
	RenderScriptCams(false,  false,  0,  true,  true)
	SetEntityCollision(GetPlayerPed(-1),  true,  true)
	SetEntityVisible(GetPlayerPed(-1),  true)
	SetNuiFocus(false, false)
	EnableAllControlActions(0)
  SetPedMaxHealth(PlayerPedId(), 200)
  SetPlayerMaxArmour(PlayerId(), 60)
  Spawn.isNew = false
end
RegisterNetEvent("ethical-spawn:characterSpawned");
AddEventHandler("ethical-spawn:characterSpawned", Login.characterSpawned);
