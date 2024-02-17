fx_version 'bodacious'
games { 'rdr3', 'gta5' }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

client_script "client.lua"
client_script "rob_ped.lua"
client_script "keys.lua"

