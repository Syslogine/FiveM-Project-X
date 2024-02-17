RegisterServerEvent("job:Pay")
AddEventHandler("job:Pay", function(data,pay)
    local src = source
    local user = exports["ethical-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    
end)

RegisterServerEvent("secondary:NewJobServerWipe")
AddEventHandler("secondary:NewJobServerWipe", function()
    local src = tonumber(source)
    local user = exports["ethical-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id
    local newjob = "none"
    exports.ghmattimysql:execute("UPDATE gang_client_reputation SET job = @job WHERE cid = @cid", {['job'] = newjob, ['cid'] = cid})
end)

RegisterServerEvent("secondary:NewJobServer")
AddEventHandler("secondary:NewJobServer", function()
    local src = tonumber(source)
    local user = exports["ethical-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id
    local newjob = newjob
    local date = os.time() + (86400 * 3)
    exports.ghmattimysql:execute("UPDATE gang_client_reputation SET job = @job, job_time = @date WHERE cid = @cid", {['job'] = newjob, ['date'] = date, ['cid'] = cid})
    TriggerClientEvent("secondaryjob:startoffjob",src,newjob)
    TriggerClientEvent("secondaryjob:ClientReturnData",src,false)
end)
