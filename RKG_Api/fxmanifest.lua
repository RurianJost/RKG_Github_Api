fx_version 'bodacious'
game 'gta5'

shared_script {
	'lib/utils.lua',
	'lib/Tools.lua',
	'lib/Proxy.lua',
	'lib/Tunnel.lua'
}

server_scripts {
	'server/javascript/*.js',

	'server/lua/main.lua',

	'server/lua/notify/*.lua',
	'server/lua/api/*.lua'
}