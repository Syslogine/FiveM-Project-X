
client_script "@ethical-errorlog/client/cl_errorlog.lua"

------
-- InteractSound by Scott
-- Verstion: v0.0.1
------

-- Manifest Version
fx_version 'cerulean'
game 'gta5'

server_script "@ethical-fml/server/lib.lua"
client_script "@ethical-infinity/client/cl_lib.lua"
server_script "@ethical-infinity/server/sv_lib.lua"

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    -- Begin Sound Files Here...
    'client/html/sounds/*.ogg'
})
