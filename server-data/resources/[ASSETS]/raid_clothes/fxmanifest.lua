fx_version 'cerulean'
game 'gta5'

ui_page 'client/html/index.html'

files {
  'client/html/*.html',
  'client/html/*.js',
  'client/html/*.css',
  'client/html/webfonts/*',
  'client/html/css/*',
}

client_scripts {
  '@ethical-errorlog/client/cl_errorlog.lua',
  'client/cl_tattooshop.lua',
  'client/cl_*.lua',
}

shared_scripts {
  'shared/sh_*.*',
}

server_scripts {
  'server.lua',
}

export "CreateHashList"
export "GetTatCategs"
export "GetCustomSkins"
