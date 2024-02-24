PXXY = exports["pxxy_core"]:getSharedObject()

if not IsDuplicityVersion() then -- Only register this event for the client
    AddEventHandler("pxxy:setPlayerData", function(key, val, last)
        if GetInvokingResource() == "pxxy_core" then
            PXXY.PlayerData[key] = val
            if OnPlayerData then
                OnPlayerData(key, val, last)
            end
        end
    end)

    RegisterNetEvent("pxxy:playerLoaded", function(xPlayer)
        PXXY.PlayerData = xPlayer
        PXXY.PlayerLoaded = true
    end)

    RegisterNetEvent("pxxy:onPlayerLogout", function()
        PXXY.PlayerLoaded = false
        PXXY.PlayerData = {}
    end)
end
