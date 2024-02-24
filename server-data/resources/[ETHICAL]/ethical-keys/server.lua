RegisterServerEvent('keys:send')
AddEventHandler('keys:send', function(player, data)
    TriggerClientEvent('keys:received', player, data)
end)

RegisterServerEvent("ethical-base:characterLoaded")
AddEventHandler("ethical-base:characterLoaded", function(user, character)
    local player = user:getVar("hexid")
    local src = user:getVar("source")

    exports.oxmysql:execute("SELECT license_plate FROM characters_cars WHERE owner = @username AND cid = @cid",{['username'] = player, ["cid"] = character.id}, function(result)
        if result then
            for k,v in ipairs(result) do
                TriggerClientEvent("keys:loadKey", src, v.license_plate)
            end
        end
    end)
end)


RegisterServerEvent('vehicle:attemptHotwire')
AddEventHandler('vehicle:attemptHotwire', function(plate)
    local _source = source
    if exports.inventory:hasItem(_source, "lockpick") then
        -- The player has a lockpick, allow hotwiring
        TriggerClientEvent('vehicle:allowHotwire', _source, plate)
    else
        -- The player does not have a lockpick, deny hotwiring
        TriggerClientEvent('DoLongHudText', _source, "You need a lockpick to hotwire vehicles!", 2)
    end
end)
