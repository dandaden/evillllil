extends VBoxContainer

const response = preload("res://02_prefabs/DebugResponse/DebugResponse.tscn")
onready var console_screen = $Console_Screen

func _input(event):
	if event.is_action_pressed("debug"):
		if Game.menu_state == Game.MENU.MAIN:
			Game.menu_state = Game.MENU.DEBUG
			visible = true
			$debug_input / HBoxContainer / input.grab_focus()
			$debug_input / HBoxContainer / input / clear.start()
		elif Game.menu_state == Game.MENU.DEBUG:
			Game.menu_state = Game.MENU.MAIN
			visible = false
			$debug_input / HBoxContainer / input.clear()

signal boomer()

func run_command(command: String):
	
	if command.empty():
		Game.menu_state = Game.MENU.MAIN
		visible = false
		$debug_input / HBoxContainer / input.clear()
	else:
		Util.log("Attempted command '%s'" % command)

	var cmd = command.split(" ")
	
	match cmd[0].to_lower():
		
		"freecandy":
			Game.loaded_level = 5
			Global.save_game()
			Util.reload_scene()

		"demogang":
			if Global.check_for_demo() == true:
				Vars.download_doc_id = "KomDog"
				Util.load_scene("res://01_scenes/06_Download/download_console.tscn")
			else:
				emit_signal("boomer")
		
		"reload":
			Util.reload_scene()

		"resetdata":
			Game.loaded_level = 0
			Global.save_game()
			Util.reload_scene()

		"version":
			add_response(command, str(ProjectSettings.get_setting("global/Version")), Color(1, 1, 1, 1))
				
		"debug":
			$debug_input / ui_mode.play()
			Game.debug_mode = true if Game.debug_mode == false else false
			var db_status = "OFF" if Game.debug_mode == false else "ON"
			add_response(command, "Debug Mode : " + db_status, Color(1, 1, 1, 1))

		"update":
			Util.load_scene("res://01_scenes/09_Update/Updater.tscn")
			
		"cheatcode":
			add_response(command, ">:(", Color(1, 1, 1, 1))
		
		"ping":
			$debug_input / ui_mode.play()
			add_response(command, "Pong! :D", Color(1, 1, 1, 1))
			
		"patreon":
			if OS.shell_open("https://patreon.com/komdog") == OK:
				$debug_input / ui_mode.play()
				add_response(command, "Opening patreon", Color(0.3, 1, 0.3, 1))
			
		"valid":
			$debug_input / ui_mode.play()
			add_response(command, "ok... you win", Color(1, 1, 1, 1))
			
		"hello":
			$debug_input / ui_mode.play()
			add_response(command, "hello!", Color(0.3, 1, 0.3, 1))

		"69":
			$debug_input / ui_mode.play()
			add_response(command, "NICE!", Color(0.3, 1, 0.3, 1))
		
		"viewlog":
			var log_path = ProjectSettings.globalize_path("user://logs/beat_banger.log")
			if OS.shell_open(log_path) == OK:
				Util.log("Opening Logs... Closing Game")
				get_tree().quit()

		"logdir":
			var log_path = ProjectSettings.globalize_path("user://logs/")
			if OS.shell_open(log_path) == OK:
				Util.log("Opening Log Directory")
				get_tree().quit()
		
		"handsfree":
			$debug_input / ui_mode.play()
			Game.autoplay = true if Game.autoplay == false else false
			var ap_status = "OFF" if Game.autoplay == false else "ON"
			add_response(command, "Autoplay Mode : " + ap_status, Color(1, 1, 1, 1))
	
		"":
			pass
			
		_:
			add_response(command, "\"" + command + "\" is not a valid command", Color(1, 0.3, 0.3, 1))
	
	$debug_input / HBoxContainer / input.clear()
	
	if $Console_Screen.get_child_count() > 4:
		$Console_Screen.get_children()[0].queue_free()
	
func clear_text():
	$debug_input / HBoxContainer / input.clear()
	
func add_response(cmd: String, res: String, col: Color):
	var response_text = response.instance()
	response_text.set_text(cmd, res)
	response_text.modulate = col
	console_screen.add_child(response_text)
