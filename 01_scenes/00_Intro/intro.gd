extends Control

func _ready():
	get_cmd_line()
	debug_init()
	Util.log("Looking for : " + Game.cur_dir + "data")
	var dir = Directory.new()
	if dir.open(Game.cur_dir + "data") == OK: return Util.log("Data loaded succesfully")
	Util.log("Could NOT find data directory")
		
func _on_animation_finished(_string):
	Util.load_scene("res://01_scenes/00_Intro/Warning.tscn")
	
func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("game_half"):
		Util.load_scene("res://01_scenes/00_Intro/Warning.tscn")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func debug_init():
	Util.log("OS Name : %s" % OS.get_name())
	Util.log("Game Version : %s" % ProjectSettings.get_setting("global/Version"))


func get_cmd_line():
	print("getting arguments")
	for argument in OS.get_cmdline_args():
		if argument.find("=") > - 1:
			var key_value = argument.split("=")
			run_commands(key_value[0].lstrip("--"), key_value[1])


func run_commands(cmd, value):
	if cmd == "load_mod":
		Game.active_level = value
		Game.target_directory = "mods"
		Util.load_scene("res://01_scenes/02_Game/Game.tscn")



	



			

	
		
		
