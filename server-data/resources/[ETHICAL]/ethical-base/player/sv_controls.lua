RegisterServerEvent("ethical-base:sv:player_control_set")
AddEventHandler("ethical-base:sv:player_control_set", function(controlsTable)
    local src = source
    ETHICAL.DB:UpdateControls(src, controlsTable, function(UpdateControls, err)
            if UpdateControls then
                -- we are good here.
            end
    end)
end)

RegisterServerEvent("ethical-base:sv:player_controls")
AddEventHandler("ethical-base:sv:player_controls", function()
    local src = source
    ETHICAL.DB:GetControls(src, function(loadedControls, err)
        if loadedControls ~= nil then 
            TriggerClientEvent("ethical-base:cl:player_control", src, loadedControls) 
        else 
            TriggerClientEvent("ethical-base:cl:player_control",src, nil) print('controls fucked') 
        end
    end)
end)
