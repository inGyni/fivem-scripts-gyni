fx_version 'bodacious'
game 'gta5'

supersede_radio 'RADIO_02_POP' { url = 'https://listener2.mp3.tb-group.fm/tb.mp3', volume = 1.0, name = 'Test Station 1' }
supersede_radio 'RADIO_03_HIPHOP_NEW' { url = 'http://stream.radioreklama.bg/nrj.ogg', volume = 1.0, name = 'Test Station 2' }

files {
	'index.html'
}

ui_page 'index.html'

client_scripts {
	'data.js',
	'client.js'
}