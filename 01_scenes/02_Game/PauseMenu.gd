extends CanvasLayer

onready var menu_options = [
	$Frame / Panel / ResumeLabel, 
	$Frame / Panel / RestartLabel, 
	$Frame / Panel / QuitLabel
]

var pause_index: int = 0

signal resumed()

func _input(event):
	if Game.menu_state == Game.MENU.INACTIVE: return
	if not get_tree().paused: return
		
	if event.is_action_pressed("ui_up"):
		pause_index = Util.value_cycle(pause_index, - 1, 0, menu_options.size() - 1)
		refresh_menu()
	elif event.is_action_pressed("ui_down"):
		pause_index = Util.value_cycle(pause_index, 1, 0, menu_options.size() - 1)
		refresh_menu()


	if event.is_action_pressed("game_half") or event.is_action_pressed("ui_accept"):
		if pause_index == 0:
			if Game.active == false: return
			get_tree().paused = not get_tree().paused
			emit_signal("resumed")
		elif pause_index == 1:
			Game.active = false
			Game.menu_state = Game.MENU.INACTIVE
			$Selected.play()
			Anims.fade_and_restart_scene($Fade, $Fade / Tween)
		elif pause_index == 2:
			Game.active = false
			Game.menu_state = Game.MENU.INACTIVE
			$Back.play()
			exit_to_menu()
		else:
			pass

func exit_to_menu():
	if Game.target_directory == "mods":
		Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/01_Menu/Mod.tscn")
	else:
		Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/01_Menu/Menu.tscn")
	
func refresh_menu():
	$MenuTick.play()
	for label in menu_options:
		label.modulate = Color(1, 1, 1, 0.2)
	menu_options[pause_index].modulate = Color(1, 1, 1, 1)


func _on_paused():
	refresh_menu()
	$Frame.visible = not $Frame.visible
	var _err = $PauseSound.play() if get_tree().paused else $UnPauseSound.play()

func _on_resumed():
	Game.free_note = true
	_on_paused()
