fx_version 'cerulean'
game 'gta5'

--resource_type 'gametype' { name = 'Hot Putsuit' }
client_script "@ethical-errorlog/client/cl_errorlog.lua"

-- server_script "@ethical-fml/server/lib.lua"
client_script "@ethical-infinity/client/cl_lib.lua"
server_script "@ethical-infinity/server/sv_lib.lua"

server_script "server.lua"
client_script "client.lua"
