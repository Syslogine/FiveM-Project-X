-- 1 + 9 + 10 + 25 + 5 + 20 + 30 = 100
RegisterServerEvent('loot:useItem')
AddEventHandler('loot:useItem', function(string)
    local src = source
    --print("shit loot")
    if string == 'houserobbery' then
        print("house robbery")
        local chance = math.random(1,100)
        TriggerClientEvent('player:receiveItem', src, "rolexwatch", math.random(1,2))
        if chance == 1 then
            -- %1 chance
            TriggerClientEvent('player:receiveItem', src, "monalisa", 1)
        elseif chance == 9 then
            -- %9 chance
            TriggerClientEvent('player:receiveItem', src, "decrypterenzo", math.random(1,2))
        elseif chance == 10 then
            -- %10 chance
            TriggerClientEvent('player:receiveItem', src, "rollcash", 100)
        elseif chance == 25 then
            -- %25 chance
            TriggerClientEvent('player:receiveItem', src, "anime", 1)
        elseif chance == 5 then
            TriggerClientEvent('player:receiveItem', src, "burialmask", 1)
        elseif chance == 20 then
            -- %20 chance
            TriggerClientEvent('player:receiveItem', src, "stoleniphone", 1)
        elseif chance == 30 then
            -- %30 chance
            TriggerClientEvent('player:receiveItem', src, "stolencasiowatch", 1)
        end
    elseif string == 'Bankbox' then
        TriggerClientEvent('player:receiveItem', src, "cashroll", math.random(1,10))
        TriggerClientEvent('player:receiveItem', src, "cashstack", math.random(1,10))
        TriggerClientEvent('player:receiveItem', src, "Gruppe6Card", math.random(1,10))
        TriggerClientEvent('player:receiveItem', src, "valuablegoods", math.random(1,10))
    elseif string == 'Securebriefcase' then
        local sex = math.random(1,2)
        if sex == 1 then
            TriggerClientEvent('player:receiveItem', src, "-879347409", 1)
        else
            TriggerClientEvent('player:receiveItem', src, "-1746263880", 1)
        end
    elseif string == "chopchop" then
        TriggerClientEvent('player:receiveItem', src, "recyclablematerial", math.random(5,15))
        local chance = math.random(1, 10)
        if chance == 10 then
            TriggerClientEvent('player:receiveItem', src, "pix1", math.random(1,3))
        end
    elseif string == "chopchoprare" then
        TriggerClientEvent('player:receiveItem', src, "recyclablematerial", math.random(7,20))
        local chance = math.random(1,20)
        if chance == 20 then
            TriggerClientEvent('player:receiveItem', src, "pix2", math.random(1,3))
        end
    end
end)

    object ={}
    object[1] = true--table
    object[2] = true -- drawers
    object[3] = true --table lamesa
    object[4] = true --storage
    object[5] = true --2nd storage
    object[6] = true --wardrobe
    object[7] = true --side table
    object[8] = true -- jewelry
    object[9] = true --bed
    object[10] = true -- cupboard
    object[11] = true --cabinet 2
    object[12] = true -- coffee table
    object[13] = true -- fridge

RegisterNetEvent('houserobberies:rob')
AddEventHandler('houserobberies:rob', function(myhouseid,i,mansion)
    local src = source
    
    if object[i] == false then
        -- TriggerClientEvent('DoLongHudText',src, 'This is already empty',2)
        TriggerClientEvent('houserobberies:item',src,true)
    else
        object[i] = false
        TriggerClientEvent('houserobberies:item',src,false)
    end
    -- print("GETTING SEARCH HERE ",myhouseid,i,mansion)
    -- 
end)
