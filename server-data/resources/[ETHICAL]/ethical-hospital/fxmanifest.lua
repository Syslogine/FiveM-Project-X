fx_version 'cerulean'
game 'gta5'

client_scripts {
	'config.lua',
	'client/wound.lua',
	'client/main.lua',
	'client/items.lua',
}

server_scripts {
	'server/wound.lua',
	'server/main.lua',
	'server/items.lua',
}

exports {
    'IsInjuredOrBleeding',
	'DoLimbAlert',
	'DoBleedAlert',
}

server_exports {
    'GetCharsInjuries',
}

fx_version 'adamant'
games { 'gta5' }