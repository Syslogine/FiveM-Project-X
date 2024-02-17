local Resource, Promises, Functions, CallIdentifier = GetCurrentResourceName(), {}, {}, 0

NPX = {}

function GetNextId(idx)
    return idx + 1
end
    

function ClearPromise(callID)
    Citizen.SetTimeout(5000, function()
        Promises[callID] = nil
    end)
end

function ParamPacker(...)
    local params, pack = {...} , {}

    for i = 1, 15, 1 do
        pack[i] = {param = params[i]}
    end

    return pack
end

function ParamUnpacker(params, index)
    local idx = index or 1

    if idx <= #params then
        return params[idx]["param"], ParamUnpacker(params, GetNextId(idx))
    end
end

function UnPacker(params, index)
    local idx = index or 1

    if idx <= 15 then
        return params[idx], UnPacker(params, GetNextId(idx))
    end
end

------------------------------------------------------------------
--                  (Trigger Client Calls)
------------------------------------------------------------------

NPX = {
    EXECUTE = {
        
    }
}

function NPXexecute(name, ...)
    local callID, solved = CallIdentifier, false
    CallIdentifier = CallIdentifier + 1

    Promises[callID] = promise:new()

    TriggerClientEvent("np:request", Resource, name, callID, ParamPacker(...), true)

    Citizen.SetTimeout(20000, function()
        if not solved then
            Promises[callID]:resolve({nil})
            TriggerClientEvent("np:server:timeout", Resource, name)
        end
    end)

    local response = Citizen.Await(Promises[callID])

    solved = true

    ClearPromise(callID)

    return ParamUnpacker(response)
end

function NPXexecuteLatent(name, timeout, ...)
    local callID, solved = CallIdentifier, false
    CallIdentifier = CallIdentifier + 1
    Promises[callID] = promise:new()

    TriggerLatentClientEvent("np:latent:request", 50000, Resource, name, callID, ParamPacker(...), true)

    Citizen.SetTimeout(timeout, function()
        if not solved then
            Promises[callID]:resolve({nil})
            TriggerClientEvent("np:server:timeout", Resource, name)
        end
    end)

    local response = Citizen.Await(Promises[callID])

    solved = true

    ClearPromise(callID)

    return ParamUnpacker(response)
end

RegisterNetEvent("np:response")
AddEventHandler("np:response", function(origin, callID, response)
    if Resource == origin and Promises[callID] then
        Promises[callID]:resolve(response)
    end
end)

------------------------------------------------------------------
--                  (Receive Remote Calls)
------------------------------------------------------------------

function NPXregister(name, func)
    Functions[name] = func
end

function NPXremove(name)
    Functions[name] = nil
end

RegisterNetEvent("np:request")
AddEventHandler("np:request", function(origin, name, callID, params)
    local response

    if Functions[name] == nil then return end

    local success, error = pcall(function()
        if packaged then
            response = ParamPacker(Functions[name](ParamUnpacker(params)))
        else
            response = ParamPacker(Functions[name](UnPacker(params)))
        end
    end)

    if not success then
        TriggerClientEvent("np:client:error", Resource, origin, name, error)
    end

    if response == nil then
        response = {}
    end

    TriggerClientEvent("np:response", origin, callID, response, true)
end)

RegisterNetEvent("np:latent:request")
AddEventHandler("np:latent:request", function(origin, name, callID, params)
    local response

    if Functions[name] == nil then return end

    local success, error = pcall(function()
        if packaged then
            response = ParamPacker(Functions[name](ParamUnpacker(params)))
        else
            response = ParamPacker(Functions[name](UnPacker(params)))
        end
    end)

    if not success then
        TriggerClientEvent("np:client:error", Resource, origin, name, error)
    end

    if response == nil then
        response = {}
    end

    TriggerLatentClientEvent("np:response", 50000, origin, callID, response,  true)
end)
