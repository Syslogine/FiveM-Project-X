fx_version 'cerulean'
game 'gta5'

client_script "@ethical-errorlog/client/cl_errorlog.lua"

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/background.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_script 'client.lua'
server_script 'server.lua'
