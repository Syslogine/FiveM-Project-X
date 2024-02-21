fx_version 'cerulean'
game 'gta5'

client_script "@ethical-errorlog/client/cl_errorlog.lua"

client_script "@ethical-infinity/client/cl_lib.lua"
server_script "@ethical-infinity/server/sv_lib.lua"

server_scripts {
	'server.lua',
	's_chopshop.lua'
}

client_scripts {
	'client.lua',
	'illegal_parts.lua',
	'chopshop.lua',
	'gui.lua'
}
