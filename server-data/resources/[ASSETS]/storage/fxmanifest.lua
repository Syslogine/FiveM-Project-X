fx_version 'cerulean'
game 'gta5'

dependency "ethical-base"
dependency "ghmattimysql"


client_script "@ethical-errorlog/client/cl_errorlog.lua"

client_script "client/cl_storage.lua"


exports {
	'tryGet',
	'remove',
	'set'
} 