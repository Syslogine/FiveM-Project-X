PXXY = {}
PXXY.Players = {}
PXXY.Jobs = {}
PXXY.JobsPlayerCount = {}
PXXY.Items = {}
Core = {}
Core.UsableItemsCallbacks = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0
Core.PlayerFunctionOverrides = {}
Core.DatabaseConnected = false
Core.playersByIdentifier = {}

Core.vehicleTypesByModel = {}

RegisterNetEvent("pxxy:onPlayerSpawn", function()
    PXXY.Players[source].spawned = true
end)

AddEventHandler("pxxy:getSharedObject", function()
    local Invoke = GetInvokingResource()
    print(("[^1ERROR^7] Resource ^5%s^7 Used the ^5getSharedObject^7 Event, this event ^1no longer exists!^7 Visit https://documentation.esx-framework.org/tutorials/tutorials-esx/sharedevent for how to fix!"):format(Invoke))
end)

exports("getSharedObject", function()
    return PXXY
end)

if Config.OxInventory then
    Config.PlayerFunctionOverride = "OxInventory"
    SetConvarReplicated("inventory:framework", "esx")
    SetConvarReplicated("inventory:weight", Config.MaxWeight * 1000)
end

local function StartDBSync()
    CreateThread(function()
        local interval <const> = 10 * 60 * 1000
        while true do
            Wait(interval)
            Core.SavePlayers()
        end
    end)
end

MySQL.ready(function()
    Core.DatabaseConnected = true
    if not Config.OxInventory then
        local items = MySQL.query.await("SELECT * FROM items")
        for _, v in ipairs(items) do
            PXXY.Items[v.name] = { label = v.label, weight = v.weight, rare = v.rare, canRemove = v.can_remove }
        end
    else
        TriggerEvent("__cfx_export_ox_inventory_Items", function(ref)
            if ref then
                PXXY.Items = ref()
            end
        end)

        AddEventHandler("ox_inventory:itemList", function(items)
            PXXY.Items = items
        end)

        while not next(PXXY.Items) do
            Wait(0)
        end
    end

    PXXY.RefreshJobs()

    print(("[^2INFO^7] ESX ^5Legacy %s^0 initialized!"):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0)))

    StartDBSync()
    if Config.EnablePaycheck then
        StartPayCheck()
    end
end)

RegisterServerEvent("pxxy:clientLog")
AddEventHandler("pxxy:clientLog", function(msg)
    if Config.EnableDebug then
        print(("[^2TRACE^7] %s^7"):format(msg))
    end
end)

RegisterNetEvent("pxxy:ReturnVehicleType", function(Type, Request)
    if Core.ClientCallbacks[Request] then
        Core.ClientCallbacks[Request](Type)
        Core.ClientCallbacks[Request] = nil
    end
end)
