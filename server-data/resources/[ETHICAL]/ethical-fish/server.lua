RegisterServerEvent('fish:checkAndTakeDepo')
AddEventHandler('fish:checkAndTakeDepo', function()
    TriggerEvent("cash:remove", source, 500)
end)

RegisterServerEvent('fish:returnDepo')
AddEventHandler('fish:returnDepo', function()
    local src = source
    local user = exports["ethical-base"]:getModule("Player"):GetUser(source)
    user:addMoney(500)
end)

RegisterServerEvent('ethical-fish:getFish')
AddEventHandler('ethical-fish:getFish', function()
    TriggerClientEvent('player:receiveItem', source, "fish", 1)
end)


RegisterServerEvent('getmoney:fish')AddEventHandler('getmoney:fish',function()local b=source;local c=exports["ethical-base"]:getModule("Player"):GetUser(b)local d=300;c:addMoney(d)end)


RegisterServerEvent('getmoney:fishok')
AddEventHandler('getmoney:fishok', function()
    local src = source
    local user = exports["ethical-base"]:getModule("Player"):GetUser(source)
    user:addMoney(170)
end)