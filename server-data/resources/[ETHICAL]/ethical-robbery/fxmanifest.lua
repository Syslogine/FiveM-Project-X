fx_version 'cerulean'
game 'gta5'

client_script "@ethical-errorlog/client/cl_errorlog.lua"

server_scripts {
    'nRobbery_list.lua',
    'smallRobbery_server.lua',
    'nRobbery_server.lua',
    'storeRobbery_server.lua'
}
client_scripts {
    'smallRobbery_client.lua',
    'nRobbery_client.lua',
    'pedRobbery_client.lua',
    'storeRobbery_client.lua'
}

server_export 'startRobbery'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/pricedown.ttf',
    'html/button.png',
    'html/electronic.png',
    'html/gruppe622.png',
    'html/gruppe62.png',
    'html/lockpick.png',
    'html/thermite.png',
    'html/airlock.png',
    'html/styles.css',
    'html/scripts.js',
    'html/debounce.min.js'
}
