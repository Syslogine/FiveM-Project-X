-- Voegt voertuigsleutels toe aan de speler's inventory
RegisterServerEvent('vehicle:addVehicleKeys')
AddEventHandler('vehicle:addVehicleKeys', function(plate)
    local src = source
    local xPlayer = PXXY.GetPlayerFromId()

    -- Vervang 'vehicle_keys' door de naam van het item in je database
    xPlayer.addInventoryItem('vehicle_keys', 1, false, {plate = plate})
end)



PXXY.RegisterServerCallback('vehicle:hasLockpick', function(source, cb)
    local xPlayer = PXXY.GetPlayerFromId(source)
    local lockpick = xPlayer.getInventoryItem('lockpick').count -- Vervang 'lockpick' door de exacte naam van je item

    cb(lockpick > 0)
end)