extends Sprite

var volume_array = [ - 80, - 36, - 24, - 12, - 6, 0]

func _ready():
	if Game.volume == null: return load_and_set_volume()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_array[Game.volume])

func load_and_set_volume():
	if Game.volume != null: return
	Global.load_game()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_array[Game.volume])

func _process(_delta):
	frame = Game.volume

func _input(event):
	
	if Game.menu_state != Game.MENU.DEBUG:
		if event.is_action_pressed("volume_up"):
			if Game.volume < 5:
				set_volume(1)
		elif event.is_action_pressed("volume_down"):
			if Game.volume > 0:
				set_volume( - 1)
	

func set_volume(rate):
	Game.volume += rate

	if volume_array[Game.volume] < - 40: return AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_array[Game.volume])
	
	visible = true
	$ui_volume.play()
	$hide_ui.start()
			
func _on_hide_ui_timeout():
	visible = false

func on_game_exiting():
	Global.save_game()
	

