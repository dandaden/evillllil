extends Node

var difficultyIndex = 0
var difficulty = ["EASY", "HARD"]

var config = ConfigFile.new()

func _ready():
	set_pause_mode(PAUSE_MODE_PROCESS)

func save_game():
	Util.log("Saving game data")
	config.set_value("save_data", "saved_level", Game.loaded_level)
	config.set_value("save_data", "high_scores", Game.high_scores)
	config.set_value("user_config", "volume", Game.volume)
	config.set_value("user_config", "seen_credits", Game.seen_credits)
	config.save("user://user_data.cfg")

func load_game():
	Util.log("Loading game data")
	if config.load("user://user_data.cfg") != OK: return restore_defaults()
	Game.load_save_data(config)
	Game.load_user_config(config)
	Keybinds.load_keybinds(config)
	

func restore_defaults():
	Util.log("No game data found... Restoring default")
	Game.restore_default_save_data(config)
	Game.restore_default_user_config(config)
	Keybinds.restore_default_keybinds(config)

	config.save("user://user_data.cfg")
	load_game()

func check_for_demo():
	var file = File.new()
	if file.open(ProjectSettings.globalize_path("user://") + "../Beat Banger Demo/beat_banger_data.json", file.READ) == OK:
		var text = file.get_as_text()
		var json = JSON.parse(text)
		file.close()
		return json.result["played_demo"]
	else:
		print("You didn't play the demo")



func _input(event):
	
	if event.is_action_pressed("fullscreen"):
		if OS.window_fullscreen == false:
			OS.window_fullscreen = true
		else:
			OS.window_fullscreen = false





	
