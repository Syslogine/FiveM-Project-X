function Login.decode(tableString)
    if tableString == nil or tableString =="" then
        return {}
    else
        return json.decode(tableString)
    end
end

RegisterServerEvent("login:getCharModels")
AddEventHandler("login:getCharModels", function(charlist, isReset)
    local src = source
    local user = exports["ethical-base"]:getModule("Player"):GetUser(src)

    local list = ""
    for i=1,#charlist do
        if i == #charlist then
            list = list..charlist[i]
        else
            list = list..charlist[i]..","
        end
    end

    if charlist == nil or json.encode(charlist) == "[]" then
        TriggerClientEvent("login:CreatePlayerCharacterPeds", src, nil, isReset)
        return
    end

    exports.ghmattimysql:execute("SELECT cc.*, cf.*, ct.* FROM character_face cf LEFT JOIN character_current cc on cc.cid = cf.cid LEFT JOIN playerstattoos ct on ct.identifier = cf.cid WHERE cf.cid IN ("..list..")", {}, function(result)
        if result then 
            local temp_data = {}

            for k,v in pairs(result) do
                temp_data[v.cid] = {
                    model = v.model,
                    drawables = Login.decode(v.drawables),
                    props = Login.decode(v.props),
                    drawtextures = Login.decode(v.drawtextures),
                    proptextures = Login.decode(v.proptextures),
                    hairColor = Login.decode(v.hairColor),
                    headBlend = Login.decode(v.headBlend),
                    headOverlay= Login.decode(v.headOverlay),
                    headStructure = Login.decode(v.headStructure),
                    tattoos = Login.decode(v.tattoos),
                }
            end
            
            for i=1, #charlist do
                if temp_data[charlist[i]] == nil then
                    temp_data[charlist[i]] = nil
                end 
            end

            TriggerClientEvent("login:CreatePlayerCharacterPeds", src, temp_data, isReset)
        end
    end)
end)

RegisterServerEvent("ethical-login:disconnectPlayer")
AddEventHandler("ethical-login:disconnectPlayer", function()
    local src = source

    DropPlayer(src, "You Disconnected")
end)

RegisterServerEvent("ethical-base:playerSessionStarted")
AddEventHandler("ethical-base:playerSessionStarted", function()
    local src = source

    Citizen.CreateThread(function()
        Citizen.Wait(600000)
        local user = exports["ethical-base"]:getModule("Player"):GetUser(src)
        if not user or not user:getVar("characterLoaded") then DropPlayer(src, "You Timed Out While Choosing a Charater") return end
    end)
end)

RegisterNetEvent('white:setMetaHere')
AddEventHandler('white:setMetaHere',function()
    local src = source
	local user = exports["ethical-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	local identifier = user:getCurrentCharacter().owner
    exports.ghmattimysql:execute("SELECT * FROM user_licenses WHERE identifier = @identifier;", {["identifier"] = identifier}, function(result)
        if result[1] then
            local data = "<b>Drivers</b> | "..result[1].drivers.." <br><b>Business</b> | "..result[1].business.." <br><b>Weapon</b> | "..result[1].weapon.." <br><b>House</b> | "..result[1].house.." <br><b>Bar</b> | "..result[1].bar.." <br>"
            TriggerClientEvent('updateLicenseString', src, data)
        else
            exports.ghmattimysql:execute('SELECT * FROM user_appertement WHERE cid = @cid', {["cid"] = cCid}, function(result)
                if result ~= nil then
                    exports.ghmattimysql:execute('INSERT INTO user_licenses (identifier, cid, drivers, weapon, business, house, bar) VALUES (@identifier, @cid, @drivers, @weapon, @business, @house, @bar)', {
                            ['identifier'] = identifier,
                            ['cid'] = cid,
                            ['drivers'] = true,
                            ['weapon'] = false,
                            ['business'] = false,
                            ['house'] = true,
                            ['bar'] = false
                        })
                        if result[1].weapon == 1 then
                            print("SEND MY LICENSE WEAPON")
                            TriggerClientEvent('wtflols',src, 1)
                        end
                end
            end)
        end
    end)
end)