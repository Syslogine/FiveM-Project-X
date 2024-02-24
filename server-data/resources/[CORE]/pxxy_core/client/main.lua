local pickups = {}

CreateThread(function()
    while not Config.Multichar do
        Wait(100)

        if NetworkIsPlayerActive(PlayerId()) then
            exports.spawnmanager:setAutoSpawn(false)
            DoScreenFadeOut(0)
            Wait(500)
            TriggerServerEvent("pxxy:onPlayerJoined")
            break
        end
    end
end)

RegisterNetEvent("pxxy:requestModel", function(model)
    PXXY.Streaming.RequestModel(model)
end)

function PXXY.SpawnPlayer(skin, coords, cb)
    local p = promise.new()
    TriggerEvent("skinchanger:loadSkin", skin, function()
        p:resolve()
    end)
    Citizen.Await(p)
    
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(playerPed, coords.heading)
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Wait(0)
    end
    FreezeEntityPosition(playerPed, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, true, false)
    TriggerEvent('playerSpawned', coords)
    cb()
end

RegisterNetEvent("pxxy:playerLoaded")
AddEventHandler("pxxy:playerLoaded", function(xPlayer, _, skin)
    PXXY.PlayerData = xPlayer

    if not Config.Multichar then
        PXXY.SpawnPlayer(skin, PXXY.PlayerData.coords, function()
            TriggerEvent("pxxy:onPlayerSpawn")
            TriggerEvent("pxxy:restoreLoadout")
            TriggerServerEvent("pxxy:onPlayerSpawn")
            TriggerEvent("pxxy:loadingScreenOff")
            ShutdownLoadingScreen()
            ShutdownLoadingScreenNui()
        end)
    end

    while not DoesEntityExist(PXXY.PlayerData.ped) do
        Wait(20)
    end
    
    PXXY.PlayerLoaded = true

    local metadata = PXXY.PlayerData.metadata

    if metadata.health then
        SetEntityHealth(PXXY.PlayerData.ped, metadata.health)
    end

    if metadata.armor and metadata.armor > 0 then
        SetPedArmour(PXXY.PlayerData.ped, metadata.armor)
    end

    local timer = GetGameTimer()
    while not HaveAllStreamingRequestsCompleted(PXXY.PlayerData.ped) and (GetGameTimer() - timer) < 2000 do
        Wait(0)
    end 

    if Config.EnablePVP then
        SetCanAttackFriendly(PXXY.PlayerData.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end

    local playerId = PlayerId()
    -- RemoveHudComponents
    for i = 1, #Config.RemoveHudComponents do
        if Config.RemoveHudComponents[i] then
            SetHudComponentPosition(i, 999999.0, 999999.0)
        end
    end

    -- DisableNPCDrops
    if Config.DisableNPCDrops then
        local weaponPickups = { `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`, `PICKUP_WEAPON_PUMPSHOTGUN` }
        for i = 1, #weaponPickups do
            ToggleUsePickupsForPlayer(playerId, weaponPickups[i], false)
        end
    end

    if Config.DisableVehicleSeatShuff then
        AddEventHandler("pxxy:enteredVehicle", function(vehicle, _, seat)
            if seat == 0 then
                SetPedIntoVehicle(PXXY.PlayerData.ped, vehicle, 0)
                SetPedConfigFlag(PXXY.PlayerData.ped, 184, true)
            end
        end)
    end

    if Config.DisableHealthRegeneration then
        SetPlayerHealthRechargeMultiplier(playerId, 0.0)
    end

    if Config.DisableWeaponWheel or Config.DisableAimAssist or Config.DisableVehicleRewards then
        CreateThread(function()
            while true do
                if Config.DisableDisplayAmmo then
                    DisplayAmmoThisFrame(false)
                end

                if Config.DisableWeaponWheel then
                    BlockWeaponWheelThisFrame()
                    DisableControlAction(0, 37, true)
                end

                if Config.DisableAimAssist then
                    if IsPedArmed(PXXY.PlayerData.ped, 4) then
                        SetPlayerLockonRangeOverride(playerId, 2.0)
                    end
                end

                if Config.DisableVehicleRewards then
                    DisablePlayerVehicleRewards(playerId)
                end

                Wait(0)
            end
        end)
    end

    -- Disable Dispatch services
    if Config.DisableDispatchServices then
        for i = 1, 15 do
            EnableDispatchService(i, false)
        end
    end

    -- Disable Scenarios
    if Config.DisableScenarios then
        local scenarios = {
            "WORLD_VEHICLE_ATTRACTOR",
            "WORLD_VEHICLE_AMBULANCE",
            "WORLD_VEHICLE_BICYCLE_BMX",
            "WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
            "WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
            "WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
            "WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
            "WORLD_VEHICLE_BICYCLE_MOUNTAIN",
            "WORLD_VEHICLE_BICYCLE_ROAD",
            "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
            "WORLD_VEHICLE_BIKER",
            "WORLD_VEHICLE_BOAT_IDLE",
            "WORLD_VEHICLE_BOAT_IDLE_ALAMO",
            "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
            "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
            "WORLD_VEHICLE_BROKEN_DOWN",
            "WORLD_VEHICLE_BUSINESSMEN",
            "WORLD_VEHICLE_HELI_LIFEGUARD",
            "WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
            "WORLD_VEHICLE_CONSTRUCTION_SOLO",
            "WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
            "WORLD_VEHICLE_DRIVE_PASSENGERS",
            "WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED",
            "WORLD_VEHICLE_DRIVE_SOLO",
            "WORLD_VEHICLE_FIRE_TRUCK",
            "WORLD_VEHICLE_EMPTY",
            "WORLD_VEHICLE_MARIACHI",
            "WORLD_VEHICLE_MECHANIC",
            "WORLD_VEHICLE_MILITARY_PLANES_BIG",
            "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
            "WORLD_VEHICLE_PARK_PARALLEL",
            "WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
            "WORLD_VEHICLE_PASSENGER_EXIT",
            "WORLD_VEHICLE_POLICE_BIKE",
            "WORLD_VEHICLE_POLICE_CAR",
            "WORLD_VEHICLE_POLICE",
            "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
            "WORLD_VEHICLE_QUARRY",
            "WORLD_VEHICLE_SALTON",
            "WORLD_VEHICLE_SALTON_DIRT_BIKE",
            "WORLD_VEHICLE_SECURITY_CAR",
            "WORLD_VEHICLE_STREETRACE",
            "WORLD_VEHICLE_TOURBUS",
            "WORLD_VEHICLE_TOURIST",
            "WORLD_VEHICLE_TANDL",
            "WORLD_VEHICLE_TRACTOR",
            "WORLD_VEHICLE_TRACTOR_BEACH",
            "WORLD_VEHICLE_TRUCK_LOGS",
            "WORLD_VEHICLE_TRUCKS_TRAILERS",
            "WORLD_VEHICLE_DISTANT_EMPTY_GROUND",
            "WORLD_HUMAN_PAPARAZZI",
        }

        for _, v in pairs(scenarios) do
            SetScenarioTypeEnabled(v, false)
        end
    end

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)
    end

    SetDefaultVehicleNumberPlateTextPattern(-1, Config.CustomAIPlates)
    StartServerSyncLoops()
end)


RegisterNetEvent("pxxy:onPlayerLogout")
AddEventHandler("pxxy:onPlayerLogout", function()
    PXXY.PlayerLoaded = false
end)

RegisterNetEvent("pxxy:setMaxWeight")
AddEventHandler("pxxy:setMaxWeight", function(newMaxWeight)
    PXXY.SetPlayerData("maxWeight", newMaxWeight)
end)

local function onPlayerSpawn()
    PXXY.SetPlayerData("ped", PlayerPedId())
    PXXY.SetPlayerData("dead", false)
end

AddEventHandler("playerSpawned", onPlayerSpawn)
AddEventHandler("pxxy:onPlayerSpawn", onPlayerSpawn)

AddEventHandler("pxxy:onPlayerDeath", function()
    PXXY.SetPlayerData("ped", PlayerPedId())
    PXXY.SetPlayerData("dead", true)
end)

AddEventHandler("skinchanger:modelLoaded", function()
    while not PXXY.PlayerLoaded do
        Wait(100)
    end
    TriggerEvent("pxxy:restoreLoadout")
end)

AddEventHandler("pxxy:restoreLoadout", function()
    PXXY.SetPlayerData("ped", PlayerPedId())

    if not Config.OxInventory then
        local ammoTypes = {}
        RemoveAllPedWeapons(PXXY.PlayerData.ped, true)

        for _, v in ipairs(PXXY.PlayerData.loadout) do
            local weaponName = v.name
            local weaponHash = joaat(weaponName)

            GiveWeaponToPed(PXXY.PlayerData.ped, weaponHash, 0, false, false)
            SetPedWeaponTintIndex(PXXY.PlayerData.ped, weaponHash, v.tintIndex)

            local ammoType = GetPedAmmoTypeFromWeapon(PXXY.PlayerData.ped, weaponHash)

            for _, v2 in ipairs(v.components) do
                local componentHash = PXXY.GetWeaponComponent(weaponName, v2).hash
                GiveWeaponComponentToPed(PXXY.PlayerData.ped, weaponHash, componentHash)
            end

            if not ammoTypes[ammoType] then
                AddAmmoToPed(PXXY.PlayerData.ped, weaponHash, v.ammo)
                ammoTypes[ammoType] = true
            end
        end
    end
end)

-- Credit: https://github.com/LukeWasTakenn, https://github.com/LukeWasTakenn/luke_garages/blob/master/client/client.lua#L331-L352
AddStateBagChangeHandler("VehicleProperties", nil, function(bagName, _, value)
    if not value then
        return
    end

    local netId = bagName:gsub("entity:", "")
    local timer = GetGameTimer()
    while not NetworkDoesEntityExistWithNetworkId(tonumber(netId)) do
        Wait(0)
        if GetGameTimer() - timer > 10000 then
            return
        end
    end

    local vehicle = NetToVeh(tonumber(netId))
    local timer2 = GetGameTimer()
    while NetworkGetEntityOwner(vehicle) ~= PlayerId() do
        Wait(0)
        if GetGameTimer() - timer2 > 10000 then
            return
        end
    end

    PXXY.Game.SetVehicleProperties(vehicle, value)
end)

RegisterNetEvent("pxxy:setAccountMoney")
AddEventHandler("pxxy:setAccountMoney", function(account)
    for i = 1, #PXXY.PlayerData.accounts do
        if PXXY.PlayerData.accounts[i].name == account.name then
            PXXY.PlayerData.accounts[i] = account
            break
        end
    end

    PXXY.SetPlayerData("accounts", PXXY.PlayerData.accounts)
end)

if not Config.OxInventory then
    RegisterNetEvent("pxxy:addInventoryItem")
    AddEventHandler("pxxy:addInventoryItem", function(item, count, showNotification)
        for k, v in ipairs(PXXY.PlayerData.inventory) do
            if v.name == item then
                PXXY.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
                PXXY.PlayerData.inventory[k].count = count
                break
            end
        end

        if showNotification then
            PXXY.UI.ShowInventoryItemNotification(true, item, count)
        end
    end)

    RegisterNetEvent("pxxy:removeInventoryItem")
    AddEventHandler("pxxy:removeInventoryItem", function(item, count, showNotification)
        for i = 1, #PXXY.PlayerData.inventory do
            if PXXY.PlayerData.inventory[i].name == item then
                PXXY.UI.ShowInventoryItemNotification(false, PXXY.PlayerData.inventory[i].label, PXXY.PlayerData.inventory[i].count - count)
                PXXY.PlayerData.inventory[i].count = count
                break
            end
        end

        if showNotification then
            PXXY.UI.ShowInventoryItemNotification(false, item, count)
        end
    end)

    RegisterNetEvent("pxxy:addWeapon")
    AddEventHandler("pxxy:addWeapon", function()
        print("[^1ERROR^7] event ^5'pxxy:addWeapon'^7 Has Been Removed. Please use ^5xPlayer.addWeapon^7 Instead!")
    end)

    RegisterNetEvent("pxxy:addWeaponComponent")
    AddEventHandler("pxxy:addWeaponComponent", function()
        print("[^1ERROR^7] event ^5'pxxy:addWeaponComponent'^7 Has Been Removed. Please use ^5xPlayer.addWeaponComponent^7 Instead!")
    end)

    RegisterNetEvent("pxxy:setWeaponAmmo")
    AddEventHandler("pxxy:setWeaponAmmo", function()
        print("[^1ERROR^7] event ^5'pxxy:setWeaponAmmo'^7 Has Been Removed. Please use ^5xPlayer.addWeaponAmmo^7 Instead!")
    end)

    RegisterNetEvent("pxxy:setWeaponTint")
    AddEventHandler("pxxy:setWeaponTint", function(weapon, weaponTintIndex)
        SetPedWeaponTintIndex(PXXY.PlayerData.ped, joaat(weapon), weaponTintIndex)
    end)

    RegisterNetEvent("pxxy:removeWeapon")
    AddEventHandler("pxxy:removeWeapon", function()
        print("[^1ERROR^7] event ^5'pxxy:removeWeapon'^7 Has Been Removed. Please use ^5xPlayer.removeWeapon^7 Instead!")
    end)

    RegisterNetEvent("pxxy:removeWeaponComponent")
    AddEventHandler("pxxy:removeWeaponComponent", function(weapon, weaponComponent)
        local componentHash = PXXY.GetWeaponComponent(weapon, weaponComponent).hash
        RemoveWeaponComponentFromPed(PXXY.PlayerData.ped, joaat(weapon), componentHash)
    end)
end

RegisterNetEvent("pxxy:setJob")
AddEventHandler("pxxy:setJob", function(Job)
    PXXY.SetPlayerData("job", Job)
end)

if not Config.OxInventory then
    RegisterNetEvent("pxxy:createPickup")
    AddEventHandler("pxxy:createPickup", function(pickupId, label, coords, itemType, name, components, tintIndex)
        local function setObjectProperties(object)
            SetEntityAsMissionEntity(object, true, false)
            PlaceObjectOnGroundProperly(object)
            FreezeEntityPosition(object, true)
            SetEntityCollision(object, false, true)

            pickups[pickupId] = {
                obj = object,
                label = label,
                inRange = false,
                coords = coords,
            }
        end

        if itemType == "item_weapon" then
            local weaponHash = joaat(name)
            PXXY.Streaming.RequestWeaponAsset(weaponHash)
            local pickupObject = CreateWeaponObject(weaponHash, 50, coords.x, coords.y, coords.z, true, 1.0, 0)
            SetWeaponObjectTintIndex(pickupObject, tintIndex)

            for _, v in ipairs(components) do
                local component = PXXY.GetWeaponComponent(name, v)
                GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
            end

            setObjectProperties(pickupObject)
        else
            PXXY.Game.SpawnLocalObject("prop_money_bag_01", coords, setObjectProperties)
        end
    end)

    RegisterNetEvent("pxxy:createMissingPickups")
    AddEventHandler("pxxy:createMissingPickups", function(missingPickups)
        for pickupId, pickup in pairs(missingPickups) do
            TriggerEvent("pxxy:createPickup", pickupId, pickup.label, vector3(pickup.coords.x, pickup.coords.y, pickup.coords.z - 1.0), pickup.type, pickup.name, pickup.components, pickup.tintIndex)
        end
    end)
end

RegisterNetEvent("pxxy:registerSuggestions")
AddEventHandler("pxxy:registerSuggestions", function(registeredCommands)
    for name, command in pairs(registeredCommands) do
        if command.suggestion then
            TriggerEvent("chat:addSuggestion", ("/%s"):format(name), command.suggestion.help, command.suggestion.arguments)
        end
    end
end)

if not Config.OxInventory then
    RegisterNetEvent("pxxy:removePickup")
    AddEventHandler("pxxy:removePickup", function(pickupId)
        if pickups[pickupId] and pickups[pickupId].obj then
            PXXY.Game.DeleteObject(pickups[pickupId].obj)
            pickups[pickupId] = nil
        end
    end)
end

function StartServerSyncLoops()
    if not Config.OxInventory then
        -- keep track of ammo

        CreateThread(function()
            local currentWeapon = { Ammo = 0 }
            while PXXY.PlayerLoaded do
                local sleep = 1500
                if GetSelectedPedWeapon(PXXY.PlayerData.ped) ~= -1569615261 then
                    sleep = 1000
                    local _, weaponHash = GetCurrentPedWeapon(PXXY.PlayerData.ped, true)
                    local weapon = PXXY.GetWeaponFromHash(weaponHash)
                    if weapon then
                        local ammoCount = GetAmmoInPedWeapon(PXXY.PlayerData.ped, weaponHash)
                        if weapon.name ~= currentWeapon.name then
                            currentWeapon.Ammo = ammoCount
                            currentWeapon.name = weapon.name
                        else
                            if ammoCount ~= currentWeapon.Ammo then
                                currentWeapon.Ammo = ammoCount
                                TriggerServerEvent("pxxy:updateWeaponAmmo", weapon.name, ammoCount)
                            end
                        end
                    end
                end
                Wait(sleep)
            end
        end)
    end
end

if not Config.OxInventory and Config.EnableDefaultInventory then
    PXXY.RegisterInput("showinv", TranslateCap("keymap_showinventory"), "keyboard", "F2", function()
        if not PXXY.PlayerData.dead then
            PXXY.ShowInventory()
        end
    end)
end

-- disable wanted level
if not Config.EnableWantedLevel then
    ClearPlayerWantedLevel(PlayerId())
    SetMaxWantedLevel(0)
end

if not Config.OxInventory then
    CreateThread(function()
        while true do
            local Sleep = 1500
            local playerCoords = GetEntityCoords(PXXY.PlayerData.ped)
            local _, closestDistance = PXXY.Game.GetClosestPlayer(playerCoords)

            for pickupId, pickup in pairs(pickups) do
                local distance = #(playerCoords - pickup.coords)

                if distance < 5 then
                    Sleep = 0
                    local label = pickup.label

                    if distance < 1 then
                        if IsControlJustReleased(0, 38) then
                            if IsPedOnFoot(PXXY.PlayerData.ped) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
                                pickup.inRange = true

                                local dict, anim = "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@", "plant_floor"
                                PXXY.Streaming.RequestAnimDict(dict)
                                TaskPlayAnim(PXXY.PlayerData.ped, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
                                RemoveAnimDict(dict)
                                Wait(1000)

                                TriggerServerEvent("pxxy:onPickup", pickupId)
                                PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            end
                        end

                        label = ("%s~n~%s"):format(label, TranslateCap("threw_pickup_prompt"))
                    end

                    PXXY.Game.Utils.DrawText3D({
                        x = pickup.coords.x,
                        y = pickup.coords.y,
                        z = pickup.coords.z + 0.25,
                    }, label, 1.2, 1)
                elseif pickup.inRange then
                    pickup.inRange = false
                end
            end
            Wait(Sleep)
        end
    end)
end

----- Admin commands from esx_adminplus

RegisterNetEvent("pxxy:tpm")
AddEventHandler("pxxy:tpm", function()
    local GetEntityCoords = GetEntityCoords
    local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
    local GetFirstBlipInfoId = GetFirstBlipInfoId
    local DoesBlipExist = DoesBlipExist
    local DoScreenFadeOut = DoScreenFadeOut
    local GetBlipInfoIdCoord = GetBlipInfoIdCoord
    local GetVehiclePedIsIn = GetVehiclePedIsIn

    PXXY.TriggerServerCallback("pxxy:isUserAdmin", function(admin)
        if not admin then
            return
        end
        local blipMarker = GetFirstBlipInfoId(8)
        if not DoesBlipExist(blipMarker) then
            PXXY.ShowNotification(TranslateCap("tpm_nowaypoint"), true, false, 140)
            return "marker"
        end

        -- Fade screen to hide how clients get teleported.
        DoScreenFadeOut(650)
        while not IsScreenFadedOut() do
            Wait(0)
        end

        local ped, coords = PXXY.PlayerData.ped, GetBlipInfoIdCoord(blipMarker)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local oldCoords = GetEntityCoords(ped)

        -- Unpack coords instead of having to unpack them while iterating.
        -- 825.0 seems to be the max a player can reach while 0.0 being the lowest.
        local x, y, groundZ, Z_START = coords["x"], coords["y"], 850.0, 950.0
        local found = false
        FreezeEntityPosition(vehicle > 0 and vehicle or ped, true)

        for i = Z_START, 0, -25.0 do
            local z = i
            if (i % 2) ~= 0 then
                z = Z_START - i
            end

            NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
            local curTime = GetGameTimer()
            while IsNetworkLoadingScene() do
                if GetGameTimer() - curTime > 1000 then
                    break
                end
                Wait(0)
            end
            NewLoadSceneStop()
            SetPedCoordsKeepVehicle(ped, x, y, z)

            while not HasCollisionLoadedAroundEntity(ped) do
                RequestCollisionAtCoord(x, y, z)
                if GetGameTimer() - curTime > 1000 then
                    break
                end
                Wait(0)
            end

            -- Get ground coord. As mentioned in the natives, this only works if the client is in render distance.
            found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
            if found then
                Wait(0)
                SetPedCoordsKeepVehicle(ped, x, y, groundZ)
                break
            end
            Wait(0)
        end

        -- Remove black screen once the loop has ended.
        DoScreenFadeIn(650)
        FreezeEntityPosition(vehicle > 0 and vehicle or ped, false)

        if not found then
            -- If we can't find the coords, set the coords to the old ones.
            -- We don't unpack them before since they aren't in a loop and only called once.
            SetPedCoordsKeepVehicle(ped, oldCoords["x"], oldCoords["y"], oldCoords["z"] - 1.0)
            PXXY.ShowNotification(TranslateCap("tpm_success"), true, false, 140)
        end

        -- If Z coord was found, set coords in found coords.
        SetPedCoordsKeepVehicle(ped, x, y, groundZ)
        PXXY.ShowNotification(TranslateCap("tpm_success"), true, false, 140)
    end)
end)

local noclip = false
local noclip_pos = vector3(0, 0, 70)
local heading = 0

local function noclipThread()
    while noclip do
        SetEntityCoordsNoOffset(PXXY.PlayerData.ped, noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

        if IsControlPressed(1, 34) then
            heading = heading + 1.5
            if heading > 360 then
                heading = 0
            end

            SetEntityHeading(PXXY.PlayerData.ped, heading)
        end

        if IsControlPressed(1, 9) then
            heading = heading - 1.5
            if heading < 0 then
                heading = 360
            end

            SetEntityHeading(PXXY.PlayerData.ped, heading)
        end

        if IsControlPressed(1, 8) then
            noclip_pos = GetOffsetFromEntityInWorldCoords(PXXY.PlayerData.ped, 0.0, 1.0, 0.0)
        end

        if IsControlPressed(1, 32) then
            noclip_pos = GetOffsetFromEntityInWorldCoords(PXXY.PlayerData.ped, 0.0, -1.0, 0.0)
        end

        if IsControlPressed(1, 27) then
            noclip_pos = GetOffsetFromEntityInWorldCoords(PXXY.PlayerData.ped, 0.0, 0.0, 1.0)
        end

        if IsControlPressed(1, 173) then
            noclip_pos = GetOffsetFromEntityInWorldCoords(PXXY.PlayerData.ped, 0.0, 0.0, -1.0)
        end
        Wait(0)
    end
end

RegisterNetEvent("pxxy:noclip")
AddEventHandler("pxxy:noclip", function()
    PXXY.TriggerServerCallback("pxxy:isUserAdmin", function(admin)
        if not admin then
            return
        end

        if not noclip then
            noclip_pos = GetEntityCoords(PXXY.PlayerData.ped, false)
            heading = GetEntityHeading(PXXY.PlayerData.ped)
        end

        noclip = not noclip
        if noclip then
            CreateThread(noclipThread)
        end

        PXXY.ShowNotification(TranslateCap("noclip_message", noclip and Translate("enabled") or Translate("disabled")), true, false, 140)
    end)
end)

RegisterNetEvent("pxxy:killPlayer")
AddEventHandler("pxxy:killPlayer", function()
    SetEntityHealth(PXXY.PlayerData.ped, 0)
end)

RegisterNetEvent("pxxy:repairPedVehicle")
AddEventHandler("pxxy:repairPedVehicle", function()
    local ped = PXXY.PlayerData.ped
    local vehicle = GetVehiclePedIsIn(ped, false)
    SetVehicleEngineHealth(vehicle, 1000)
    SetVehicleEngineOn(vehicle, true, true)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0)
end)

RegisterNetEvent("pxxy:freezePlayer")
AddEventHandler("pxxy:freezePlayer", function(input)
    local player = PlayerId()
    if input == "freeze" then
        SetEntityCollision(PXXY.PlayerData.ped, false)
        FreezeEntityPosition(PXXY.PlayerData.ped, true)
        SetPlayerInvincible(player, true)
    elseif input == "unfreeze" then
        SetEntityCollision(PXXY.PlayerData.ped, true)
        FreezeEntityPosition(PXXY.PlayerData.ped, false)
        SetPlayerInvincible(player, false)
    end
end)

PXXY.RegisterClientCallback("pxxy:GetVehicleType", function(cb, model)
    cb(PXXY.GetVehicleType(model))
end)

AddStateBagChangeHandler("metadata", "player:" .. tostring(GetPlayerServerId(PlayerId())), function(_, key, val)
    PXXY.SetPlayerData(key, val)
end)
