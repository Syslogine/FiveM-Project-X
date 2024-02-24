local searchedVehicles = {}
local vehicleKeys = {}

-- Functie om te controleren of de speler sleutels heeft voor het huidige voertuig
function DoesPlayerHaveVehicleKeys(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    return vehicleKeys[plate] == true
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Dit zorgt voor een snelle respons op toetsaanslagen

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsUsing(playerPed)

        if IsPedInAnyVehicle(playerPed, false) then
            -- Controleer of de speler in de bestuurdersstoel zit
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                -- Voorkom dat de motor automatisch start als de speler niet de juiste sleutels heeft
                if not DoesPlayerHaveVehicleKeys(vehicle) then
                    SetVehicleEngineOn(vehicle, false, false, false)
                end

                -- Zoeken met G-toets
                if IsControlJustReleased(0, 47) then
                    if not searchedVehicles[vehicle] then
                        TriggerEvent('vehicle:searchAndHotwireVehicle', true) -- true duidt op zoeken
                    else
                        TriggerEvent("DoLongHudText", "Je hebt al gezocht in dit voertuig.", 1)
                    end
                -- Hotwiren met H-toets
                elseif IsControlJustReleased(0, 74) then
                    if not searchedVehicles[vehicle] then
                        TriggerEvent('vehicle:searchAndHotwireVehicle', false) -- false duidt op hotwiren
                    else
                        TriggerEvent("DoLongHudText", "Je hebt dit voertuig al gehotwired of de sleutels gevonden.", 1)
                    end
                end
            end
        else
            -- Verhoog de wachttijd als de speler niet in een voertuig zit om de prestaties te sparen
            Citizen.Wait(500)
        end
    end
end)


-- Verwerking van zoeken naar sleutels of hotwiren
RegisterNetEvent('vehicle:searchAndHotwireVehicle')
AddEventHandler('vehicle:searchAndHotwireVehicle', function(isSearching)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(playerPed)
    local plate = GetVehicleNumberPlateText(vehicle)

    if not vehicle or vehicle == 0 or searchedVehicles[vehicle] then return end
    
    searchedVehicles[vehicle] = true

    if isSearching then
        -- Start het zoekproces
        local searchResult = exports["ethical-taskbar"]:taskBar(5000, "Searching Vehicle")
        if searchResult ~= 100 then return end

        -- Stel een kleine kans in om de sleutels te vinden, bijv. 20%
        if math.random(1, 100) <= 20 then
            vehicleKeys[plate] = true
            TriggerServerEvent('vehicle:addVehicleKeys', plate)
            TriggerEvent("DoLongHudText", "Je hebt de sleutels gevonden.", 1)
        else
            TriggerEvent("DoLongHudText", "Geen sleutels gevonden.", 2)
        end
    else
       -- Eerst controleren of de speler een lockpick heeft
        PXXY.TriggerServerCallback('vehicle:hasLockpick', function(hasLockpick)
            if hasLockpick then
                local hotwireSuccess = exports["ethical-taskbar"]:taskBar(15000, "Attempting Hotwire")
                if hotwireSuccess == 100 and math.random(1, 100) <= 50 then
                    vehicleKeys[plate] = true
                    TriggerServerEvent('vehicle:addVehicleKeys', plate)
                    TriggerEvent("DoLongHudText", "Je hebt het voertuig succesvol gehotwired.", 1)
                else
                    TriggerEvent("DoLongHudText", "Hotwire poging mislukt.", 2)
                end
            else
                TriggerEvent("DoLongHudText", "Je hebt een lockpick nodig om te hotwiren.", 2)
            end
        end)
    end
end)


-- Toevoegen van sleutels aan lokale cache wanneer deze ontvangen zijn
RegisterNetEvent('vehicle:keysAdded')
AddEventHandler('vehicle:keysAdded', function(plate)
    vehicleKeys[plate] = true
    TriggerEvent("DoLongHudText", "Sleutels toegevoegd aan je sleutelhanger.", 1)
end)
