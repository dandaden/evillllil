extends Control

var level_dirs: Array = []
var level_names: Array = []
var level_buttons: Array = []

var levelObj = preload("res://02_prefabs/LevelButton/LevelButton.tscn")
var appended_levelObj


func load_dirs():
	Util.log("Loading levels from /Data/")
	
	var dir = Directory.new()
	if dir.open(Game.cur_dir + "/Data/") == OK:
		
		dir.list_dir_begin(true, true)
		
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if dir.file_exists(Game.cur_dir + "/Data/" + file_name + "/chart.cfg"):
					level_dirs.append(file_name)
					level_names.append(file_name.substr(3, - 1))
					Util.log("Located: /Data/" + file_name)
				else:
					print("Cound not get chart for " + file_name)
			file_name = dir.get_next()

		print(file_name)

	
func add_buttons():
	
	for i in level_names.size():
		
		appended_levelObj = levelObj.instance()
		appended_levelObj.addText(level_names[i], i)
		$buttons.add_child(appended_levelObj)
		
		level_buttons.append(appended_levelObj)
		
		appended_levelObj.position = Vector2(350, (140 * i) + 400)

var lvl_index = 0
	
func shift_buttons(event):
	if event.is_action_pressed("ui_up"):
		lvl_index = Util.value_cycle(lvl_index, - 1, 0, level_names.size() - 1)
		get_parent().play_ui_sound(2)
		
	elif event.is_action_pressed("ui_down"):
		lvl_index = Util.value_cycle(lvl_index, 1, 0, level_names.size() - 1)
		get_parent().play_ui_sound(3)

	if event.is_action_pressed("game_quarter"):
		
		Game.menu_state = Game.MENU.MAIN
		get_parent().play_ui_sound(4)
	
	var button_new_pos
	for i in level_buttons.size():
		button_new_pos = offset(Vector2(350, 100), i, lvl_index)
		level_buttons[i].modulate = Color(0.1, 0.1, 0.1, 0.8)
		level_buttons[lvl_index].modulate = Color(1, 1, 1, 1)
		$buttons / Tween.interpolate_property(
			level_buttons[i], 
			"position", 
			level_buttons[i].position, 
			button_new_pos, 
			0.3, 
			Tween.TRANS_EXPO, 
			Tween.EASE_OUT
		)
		$buttons / Tween.start()
	

func offset(position, step, selected):
	
	var button_offset_x
	
	var button_space_y = (1 + step) * 110
	var button_selected_pos_y = selected * - 110
	
	button_offset_x = 0 if step == selected else 110
	
	var newPos = Vector2(position.x + (button_offset_x), position.y + (button_space_y + button_selected_pos_y))
	
	return newPos
		

func check_level_locked(destination):
	
	if level_buttons.size() == 0: return

	
	if destination == "game":
		if Game.loaded_level < lvl_index: return get_parent().play_ui_sound(1)
		get_parent().play_ui_sound(0)
		setup_level()
		Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/02_Game/Game.tscn")
	elif destination == "gallery":
		if Game.loaded_level < lvl_index + 1: return get_parent().play_ui_sound(1)
		get_parent().play_ui_sound(5)
		setup_level()
		Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/08_Gallery/Gallery.tscn")

func setup_level():
	
	Game.active_level = level_dirs[lvl_index]
	Game.active_level_index = lvl_index
	Game.target_directory = "data"
	Game.menu_state = Game.MENU.INACTIVE




