local isInVehicle, isEnteringVehicle, isJumping, inPauseMenu = false, false, false, false
local playerPed = PlayerPedId()
local current = {}

local function GetPedVehicleSeat(ped, vehicle)
    for i = -1, 16 do
        if GetPedInVehicleSeat(vehicle, i) == ped then
            return i
        end
    end
    return -1
end

local function GetData(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end
    local model = GetEntityModel(vehicle)
    local displayName = GetDisplayNameFromVehicleModel(model)
    local netId = vehicle
    if NetworkGetEntityIsNetworked(vehicle) then
        netId = VehToNet(vehicle)
    end
    return displayName, netId
end

CreateThread(function()
    while not PXXY.PlayerLoaded do Wait(200) end
    while true do
        PXXY.SetPlayerData("coords", GetEntityCoords(playerPed))
        if playerPed ~= PlayerPedId() then
            playerPed = PlayerPedId()
            PXXY.SetPlayerData("ped", playerPed)
            TriggerEvent("pxxy:playerPedChanged", playerPed)
            TriggerServerEvent("pxxy:playerPedChanged", PedToNet(playerPed))
            if Config.DisableHealthRegeneration then
                SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            end
        end

        if IsPedJumping(playerPed) and not isJumping then
            isJumping = true
            TriggerEvent("pxxy:playerJumping")
            TriggerServerEvent("pxxy:playerJumping")
        elseif not IsPedJumping(playerPed) and isJumping then
            isJumping = false
        end

        if IsPauseMenuActive() and not inPauseMenu then
            inPauseMenu = true
            TriggerEvent("pxxy:pauseMenuActive", inPauseMenu)
        elseif not IsPauseMenuActive() and inPauseMenu then
            inPauseMenu = false
            TriggerEvent("pxxy:pauseMenuActive", inPauseMenu)
        end

        if not isInVehicle and not IsPlayerDead(PlayerId()) then
            if DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and not isEnteringVehicle then
                -- trying to enter a vehicle!
                local vehicle = GetVehiclePedIsTryingToEnter(playerPed)
                local plate = GetVehicleNumberPlateText(vehicle)
                local seat = GetSeatPedIsTryingToEnter(playerPed)
                local _, netId = GetData(vehicle)
                isEnteringVehicle = true
                TriggerEvent("pxxy:enteringVehicle", vehicle, plate, seat, netId)
                TriggerServerEvent("pxxy:enteringVehicle", plate, seat, netId)
            elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and not IsPedInAnyVehicle(playerPed, true) and isEnteringVehicle then
                -- vehicle entering aborted
                TriggerEvent("pxxy:enteringVehicleAborted")
                TriggerServerEvent("pxxy:enteringVehicleAborted")
                isEnteringVehicle = false
            elseif IsPedInAnyVehicle(playerPed, false) then
                -- suddenly appeared in a vehicle, possible teleport
                isEnteringVehicle = false
                isInVehicle = true
                current.vehicle = GetVehiclePedIsUsing(playerPed)
                current.seat = GetPedVehicleSeat(playerPed, current.vehicle)
                current.plate = GetVehicleNumberPlateText(current.vehicle)
                current.displayName, current.netId = GetData(current.vehicle)
                TriggerEvent("pxxy:enteredVehicle", current.vehicle, current.plate, current.seat, current.displayName, current.netId)
                TriggerServerEvent("pxxy:enteredVehicle", current.plate, current.seat, current.displayName, current.netId)
            end
        elseif isInVehicle then
            if not IsPedInAnyVehicle(playerPed, false) or IsPlayerDead(PlayerId()) then
                -- bye, vehicle
                TriggerEvent("pxxy:exitedVehicle", current.vehicle, current.plate, current.seat, current.displayName, current.netId)
                TriggerServerEvent("pxxy:exitedVehicle", current.plate, current.seat, current.displayName, current.netId)
                isInVehicle = false
                current = {}
            end
        end
        Wait(200)
    end
end)

if Config.EnableDebug then
    AddEventHandler("pxxy:playerPedChanged", function(netId)
        print("pxxy:playerPedChanged", netId)
    end)

    AddEventHandler("pxxy:playerJumping", function()
        print("pxxy:playerJumping")
    end)

    AddEventHandler("pxxy:enteringVehicle", function(vehicle, plate, seat, netId)
        print("pxxy:enteringVehicle", "vehicle", vehicle, "plate", plate, "seat", seat, "netId", netId)
    end)

    AddEventHandler("pxxy:enteringVehicleAborted", function()
        print("pxxy:enteringVehicleAborted")
    end)

    AddEventHandler("pxxy:enteredVehicle", function(vehicle, plate, seat, displayName, netId)
        print("pxxy:enteredVehicle", "vehicle", vehicle, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)

    AddEventHandler("pxxy:exitedVehicle", function(vehicle, plate, seat, displayName, netId)
        print("pxxy:exitedVehicle", "vehicle", vehicle, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)
end
