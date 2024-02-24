fx_version 'cerulean'
game 'gta5'


client_script "@ethical-errorlog/client/cl_errorlog.lua"

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/backgroundwhite.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_scripts {
	'main.lua',
}

server_script "server.lua"
