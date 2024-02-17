resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
ui_page('html/index.html')
client_script "@ethical-errorlog/client/cl_errorlog.lua"

client_script "@ethical-infinity/client/cl_lib.lua"
server_script "@ethical-infinity/server/sv_lib.lua"

files {
	"html/index.html",
	"html/sounds/panic.mp3",
	"html/sounds/metaldetected.mp3",
}

client_script 'client.lua'
server_script 'server.lua'