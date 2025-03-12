extends Control

onready var menus = [
	$Menu_Main, 
	$Menu_Options, 
	$Menu_Level_Select
]

onready var themes = [
	$menu_theme, 
	$menu_theme2, 
	$menu_theme3
]

func _ready():
	Util.log("----- Main menu loaded")
	OS.set_window_title("Beat Banger")
	$Menu_Level_Select.load_dirs()
	$Menu_Level_Select.add_buttons()

	music_change(0)
	Game.menu_state = Game.MENU.MAIN

	for n in range(0, menus.size()):
		menus[n].visible = false
	menus[Game.menu_state].visible = true

	$Background.material.set_shader_param("wobble", 0.05)
	
	introAnimation()
	
	

func _on_got_update(version):
	if ProjectSettings.get_setting("global/Version") >= float(version):
		$Version.text = "Beat Banger v%s" % ProjectSettings.get_setting("global/Version")
		Util.log("Running on %s" % $Version.text)
	else:
		$Version.text = "Current Version %s / Lastest Release %s" % [ProjectSettings.get_setting("global/Version"), version]
		$Updater / UpdateSound.play()
		$Updater / UpdateVisual / UpdateText.visible = true
		$Updater / UpdateVisual / UpdateText / ClickMe.text = "CLICK ME TO DOWNLOAD v%s" % Vars.latest_release
		Util.log("Running on outdated version of the game... Update recommended")
	
func introAnimation():
	
	$Flash.visible = true
	$Flash / AnimationPlayer.play("FadeIn")
	
	$Menu_Main / Title / Tween.interpolate_property($Menu_Main / Title, "scale", Vector2(0, 0), Vector2(1, 1), Game.menu_bpm * 2, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Menu_Main / Title / Tween.start()
	$Menu_Main / Title / pulse.wait_time = Game.menu_bpm

func music_change(index):
	for t in themes:
		t.volume_db = - 80
	themes[index].volume_db = 0
	
	
func _input(event):
	
	if (event is InputEventKey) or (event is InputEventMouseButton and event.button_mask != 1):

		
		if Game.menu_state == Game.MENU.MAIN:
			$Updater / UpdateVisual.visible = true
			music_change(0)
			update_menu()

			$Menu_Main.shift_label(event)
		
			
			if event.is_action_pressed("ui_accept") or event.is_action_pressed("game_half"):
				$Menu_Main.check_option()
				

		
		elif Game.menu_state == Game.MENU.OPTIONS:
			$Updater / UpdateVisual.visible = false
			music_change(2)
			update_menu()

			$Menu_Options.handle_event(event)

		
		elif Game.menu_state == Game.MENU.LEVELS:
			$Updater / UpdateVisual.visible = false
			music_change(1)
			update_menu()
			
			$Menu_Level_Select.shift_buttons(event)
				
			
			if event.is_action_pressed("ui_accept") or event.is_action_pressed("game_half"):
				$Menu_Level_Select.check_level_locked("game")
			elif event.is_action_pressed("debug"):
				$Menu_Level_Select.check_level_locked("gallery")
				
		


func update_menu():

	for n in range(0, menus.size()):
		menus[n].visible = false
	menus[Game.menu_state].visible = true

onready var ui_sounds = [
	$Sfx / ui_accept, 
	$Sfx / ui_tick, 
	$Sfx / ui_select, 
	$Sfx / ui_select_inv, 
	$Sfx / ui_back, 
	$Sfx / ui_gallery
]

func play_ui_sound(type):
	ui_sounds[type].play()


func fade_out():

	
	$menu_theme / Tween.interpolate_property($menu_theme, "volume_db", - 3, - 99, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$menu_theme / Tween.start()

	$menu_theme2 / Tween.interpolate_property($menu_theme2, "volume_db", - 3, - 99, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$menu_theme2 / Tween.start()

	$menu_theme3 / Tween.interpolate_property($menu_theme3, "volume_db", - 3, - 99, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$menu_theme3 / Tween.start()


func _on_pulse_timeout():
	$Menu_Main / Title / Tween.interpolate_property($Menu_Main / Title, "scale", Vector2(1.1, 1.1), Vector2(1, 1), 1.0)
	$Menu_Main / Title / Tween.start()
	$Menu_Level_Select / top_bar / Tween.interpolate_property($Menu_Level_Select / top_bar, "color", Color(1, 1, 1, 1), Color(1, 1, 1, 0.2), 1.0)
	$Menu_Level_Select / top_bar / Tween.start()

