RegisterServerEvent("pxxy:playerPedChanged")
RegisterServerEvent("pxxy:playerJumping")
RegisterServerEvent("pxxy:enteringVehicle")
RegisterServerEvent("pxxy:enteringVehicleAborted")
RegisterServerEvent("pxxy:enteredVehicle")
RegisterServerEvent("pxxy:exitedVehicle")

if Config.EnableDebug then
    AddEventHandler("pxxy:playerPedChanged", function(netId)
        print("pxxy:playerPedChanged", source, netId)
    end)

    AddEventHandler("pxxy:playerJumping", function()
        print("pxxy:playerJumping", source)
    end)

    AddEventHandler("pxxy:enteringVehicle", function(plate, seat, netId)
        print("pxxy:enteringVehicle", "source", source, "plate", plate, "seat", seat, "netId", netId)
    end)

    AddEventHandler("pxxy:enteringVehicleAborted", function()
        print("pxxy:enteringVehicleAborted", source)
    end)

    AddEventHandler("pxxy:enteredVehicle", function(plate, seat, displayName, netId)
        print("pxxy:enteredVehicle", "source", source, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)

    AddEventHandler("pxxy:exitedVehicle", function(plate, seat, displayName, netId)
        print("pxxy:exitedVehicle", "source", source, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)
end
