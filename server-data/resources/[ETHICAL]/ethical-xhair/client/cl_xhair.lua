local xhairActive = false
local disableXhair = false

RegisterNetEvent('hunting:onxhair')
AddEventHandler('hunting:onxhair', function(xhair)
    xhairActive = xhair
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local get_ped = PlayerPedId()
        local get_ped_veh = GetVehiclePedIsIn(get_ped, false)

        if not disableXhair and not xhairActive and IsPedArmed(get_ped, 7) then
            xhairActive = true
            SendNUIMessage("xhairShow")
        elseif not IsPedArmed(PlayerPedId(), 7) and xhairActive then
            xhairActive = false
            SendNUIMessage("xhairHide")
        end
    end
end)