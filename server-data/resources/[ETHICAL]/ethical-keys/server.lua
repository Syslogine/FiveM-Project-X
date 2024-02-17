RegisterServerEvent('keys:send')
AddEventHandler('keys:send', function(player, data)
    TriggerClientEvent('keys:received', player, data)
end)

RegisterServerEvent("ethical-base:characterLoaded")
AddEventHandler("ethical-base:characterLoaded", function(user, character)
    local player = user:getVar("hexid")
    local src = user:getVar("source")

    exports.ghmattimysql:execute("SELECT license_plate FROM characters_cars WHERE owner = @username AND cid = @cid",{['username'] = player, ["cid"] = character.id}, function(result)
        if result then
            for k,v in ipairs(result) do
                TriggerClientEvent("keys:loadKey", src, v.license_plate)
            end
        end
    end)
end)
