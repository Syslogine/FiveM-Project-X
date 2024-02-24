fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'
server_script 'server.lua'


client_script "@ethical-errorlog/client/cl_errorlog.lua"

server_export 'getWeaponMetaData'
server_export "updateWeaponMetaData"

exports{
	'toName',
	'findModel'
}
