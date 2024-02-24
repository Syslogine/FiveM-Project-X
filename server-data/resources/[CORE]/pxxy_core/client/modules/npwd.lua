local npwd = GetResourceState("npwd"):find("start") and exports.npwd or nil

local function checkPhone()
    if not npwd then
        return
    end

    local phoneItem <const> = PXXY.SearchInventory("phone")
    npwd:setPhoneDisabled((phoneItem and phoneItem.count or 0) <= 0)
end

RegisterNetEvent("pxxy:playerLoaded", checkPhone)

AddEventHandler("onClientResourceStart", function(resource)
    if resource ~= "npwd" then
        return
    end

    npwd = GetResourceState("npwd"):find("start") and exports.npwd or nil

    if PXXY.PlayerLoaded then
        checkPhone()
    end
end)

AddEventHandler("onClientResourceStop", function(resource)
    if resource == "npwd" then
        npwd = nil
    end
end)

RegisterNetEvent("pxxy:onPlayerLogout", function()
    if not npwd then
        return
    end

    npwd:setPhoneVisible(false)
    npwd:setPhoneDisabled(true)
end)

RegisterNetEvent("pxxy:removeInventoryItem", function(item, count)
    if not npwd then
        return
    end

    if item == "phone" and count == 0 then
        npwd:setPhoneDisabled(true)
    end
end)

RegisterNetEvent("pxxy:addInventoryItem", function(item)
    if not npwd or item ~= "phone" then
        return
    end

    npwd:setPhoneDisabled(false)
end)
