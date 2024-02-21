ETHICAL.Admin.DB = ETHICAL.Admin.DB or {}

RegisterServerEvent('ethical-admin:searchRequest')
AddEventHandler('ethical-admin:searchRequest', function()
    local q = [[SELECT hex_id FROM users WHERE hex_id = @id LIMIT 1;]]
    local v = {["id"] = hexId}

    
end)

function ETHICAL.Admin.DB.giveCar(car, cid)
    local q = [[INSERT INTO characters_cars (owner, cid, model, vehicle_state, fuel, engine_damage, body_damage, current_garage, license_plate)
    VALUES(@owner, @cid, @model, @vehicle_state, @fuel, @engine_damage, @body_damage, @current_garage, @license_plate);]]
    local v = {
    ["owner"] = data.hexid,
    ["cid"] = cid,
    ["model"] = car,
    ["vehicle_state"] = "In",
    ["fuel"] = 100,
    ["engine_damage"] = 1000,
    ["body_damage"] = 1000,
    ["current_garage"] = "T",
    ["license_plate"] = math.random(10000,99999) 
    }

    exports.oxmysql:execute(q, v, function()

    end)
end

function ETHICAL.Admin.DB.UnbanSteamId(steamid)
    local q = [[DELETE FROM user_bans WHERE steam_id = @id;]]
    local v = {
    ["id"] = steamid
    }

    exports.oxmysql:execute(q, v, function()

    end)
end

function ETHICAL.Admin.DB.IsPlayerBanned(target, callback)
    local user = exports["ethical-base"]:getModule("Player"):GetUser(target)
    local steamid = user:getVar("hexid")

    local q = [[SELECT * FROM user_bans WHERE steam_id = @id LIMIT 1;]]
    local v = {["id"] = steamid}

    exports.oxmysql:execute(q, v, function(result)
        if not result then callback(false, true) return else callback(true,false) end

    end)
end