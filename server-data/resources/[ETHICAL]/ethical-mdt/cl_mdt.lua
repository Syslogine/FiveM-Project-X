local isVisible = false
local tabletObject = nil

TriggerServerEvent("ethical-mdt:getOffensesAndOfficer")

RegisterNetEvent("ethical-mdt:sendNUIMessage")
AddEventHandler("ethical-mdt:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterCommand('mdt', function()
    print("FUCKKKKK")
    TriggerServerEvent('ethical-mdt:hotKeyOpen')
end)

RegisterNetEvent('ethical-mdt:hotKeyOpen')
AddEventHandler('ethical-mdt:hotKeyOpen', function()
    TriggerServerEvent('ethical-mdt:hotKeyOpen')
end)

RegisterNetEvent("ethical-mdt:toggleVisibilty")
AddEventHandler("ethical-mdt:toggleVisibilty", function(reports, warrants, officer)
    local playerPed = PlayerPedId()
    if not isVisible then
        local dict = "amb@world_human_seat_wall_tablet@female@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
            AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
    end
    if #warrants == 0 then warrants = false end
    if #reports == 0 then reports = false end
    SendNUIMessage({
        type = "recentReportsAndWarrantsLoaded",
        reports = reports,
        warrants = warrants,
        officer = officer
    })
    ToggleGUI()
    TriggerServerEvent("ethical-mdt:getOffensesAndOfficer")
end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("performOffenderSearch", function(data, cb)
    TriggerServerEvent("ethical-mdt:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("ethical-mdt:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("evFile", function(data, cb)
    TriggerServerEvent("npLockers:sendCaseFileID", data.id)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)
    TriggerServerEvent("ethical-mdt:saveOffenderChanges", data.id, data.changes, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("ethical-mdt:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("ethical-mdt:performReportSearch", data.query)
    print("[CLIENT MDT] ",data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("ethical-mdt:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("ethical-mdt:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("ethical-mdt:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("ethical-mdt:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("ethical-mdt:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("ethical-mdt:getWarrants")
    cb('ok')
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("ethical-mdt:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("ethical-mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("ethical-mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("ethical-mdt:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("sentencePlayer", function(data, cb)
    local players = {}
    for i = 0, 256 do
        if GetPlayerServerId(i) ~= 0 then
            table.insert(players, GetPlayerServerId(i))
        end
    end
    TriggerServerEvent("ethical-mdt:sentencePlayer", data.jailtime, data.charges, data.char_id, data.fine, players)
    cb('ok')
end)

RegisterNetEvent("ethical-mdt:returnOffenderSearchResults")
AddEventHandler("ethical-mdt:returnOffenderSearchResults", function(results)
    print(json.encode(results))
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("ethical-mdt:returnOffenderDetails")
AddEventHandler("ethical-mdt:returnOffenderDetails", function(data)
    print("SENDING OFFER DETAILS", json.encode(data))
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("ethical-mdt:returnOffensesAndOfficer")
AddEventHandler("ethical-mdt:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("ethical-mdt:returnReportSearchResults")
AddEventHandler("ethical-mdt:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("ethical-mdt:returnVehicleSearchInFront")
AddEventHandler("ethical-mdt:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("ethical-mdt:returnVehicleSearchResults")
AddEventHandler("ethical-mdt:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("ethical-mdt:returnVehicleDetails")
AddEventHandler("ethical-mdt:returnVehicleDetails", function(data)
    data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("ethical-mdt:returnWarrants")
AddEventHandler("ethical-mdt:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("ethical-mdt:completedWarrantAction")
AddEventHandler("ethical-mdt:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("ethical-mdt:returnReportDetails")
AddEventHandler("ethical-mdt:returnReportDetails", function(data)
    SendNUIMessage({
        type = "returnedReportDetails",
        details = data
    })
end)

RegisterNetEvent("ethical-mdt:billPlayer")
AddEventHandler("ethical-mdt:billPlayer", function(src, sharedAccountName, label, amount)
    TriggerServerEvent("ethical-billing:sendBill", src, sharedAccountName, label, amount)
end)

function ToggleGUI(explicit_status)
  if explicit_status ~= nil then
    isVisible = explicit_status
  else
    isVisible = not isVisible
  end
  SetNuiFocus(isVisible, isVisible)
  SendNUIMessage({
    type = "enable",
    isVisible = isVisible
  })
end

function getVehicleInFront()
    local playerPed = PlayerPedId()
    local coordA = GetEntityCoords(playerPed, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end
