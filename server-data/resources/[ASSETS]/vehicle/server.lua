-- Zorg ervoor dat je framework-object correct is geïnitialiseerd
local PXXY = nil
TriggerEvent('pxxy:getSharedObject', function(obj) PXXY = obj end)

-- Voegt voertuigsleutels toe aan de speler's inventory
RegisterServerEvent('vehicle:addVehicleKeys')
AddEventHandler('vehicle:addVehicleKeys', function(plate)
    local _source = source
    local xPlayer = PXXY.GetPlayerFromId(_source)  -- Zorg ervoor dat je de '_source' parameter gebruikt

    -- Vervang 'vehicle_keys' door de naam van het item in je database
    -- Controleer of 'vehicle_keys' correct is gedefinieerd in je items database
    xPlayer.addInventoryItem('vehicle_keys', 1, {plate = plate})  -- Verwijder 'false', afhankelijk van je framework versie
end)

-- Server Callback om te controleren of de speler een lockpick heeft
PXXY.RegisterServerCallback('vehicle:hasLockpick', function(source, cb)
    local xPlayer = PXXY.GetPlayerFromId(source)
    local lockpick = xPlayer.getInventoryItem('lockpick').count  -- Zorg ervoor dat 'lockpick' correct is gedefinieerd in je items database

    cb(lockpick > 0)  -- Roept de callback functie aan met 'true' als de speler ten minste één lockpick heeft, anders 'false'
end)
