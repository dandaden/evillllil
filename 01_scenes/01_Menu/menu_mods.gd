extends Control

var mods = []
var mod_index = 0

var mods_obj = preload("res://02_prefabs/ModButton/ModButton.tscn")
var download_obj = preload("res://02_prefabs/ModButton/DownloadButton.tscn")

var appended_mods_obj
var mods_buttons = []

func _ready():

	Game.menu_state = Game.MENU.MODS
	Anims.fade_music($Music, $Music / Tween, "fade_in")
	Anims.fade_out($Overlay / Fade, $Overlay / Fade / Tween)
	_load_mods()
	add_buttons_mod()
	

	$Overlay / Fade.visible = true
	$Label2.text = "Press %s to go back" % Keybinds.key_quarter_text
	$Label3.text = "Press %s to load level" % Keybinds.key_half_text



func _load_mods():
	Util.log("Loading levels from mods/")
	
	var dir = Directory.new()
	if dir.open(Game.cur_dir + "mods/") == OK:
		
		dir.list_dir_begin(true, true)
		
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if dir.file_exists(Game.cur_dir + "mods/" + file_name + "/chart.cfg"):
					get_song_data(file_name)
					
			file_name = dir.get_next()

var mod_title: String
var mod_creator: String
var mod_artist: String
var song_artist: String
var song_title: String
var length: String

var level_name
var song_credits

func get_song_data(file_name):
	var config = ConfigFile.new()

	if config.load(Game.cur_dir + "mods/" + file_name + "/chart.cfg") == OK:
		var section = Global.difficulty[Global.difficultyIndex]
		level_name = config.get_value(section, "name", "Untitled")
		song_credits = config.get_value(section, "song_credits", "No song title found")

	if config.load(Game.cur_dir + "mods/" + file_name + "/meta.cfg") == OK:
		var section = "META"
		mod_title = config.get_value(section, "mod_title", "None")
		mod_creator = config.get_value(section, "mod_creator", "None")
		mod_artist = config.get_value(section, "mod_artist", "None")
		song_artist = config.get_value(section, "song_artist", "None")
		song_title = config.get_value(section, "song_title", "No song title found")
		length = config.get_value(section, "length", "None")
	else:
		mod_title = level_name
		mod_creator = "None"
		mod_artist = "None"
		song_artist = "None"
		song_title = "No Song Found"
		length = "None"

	mods.append({
		"level_name": level_name, 
		"file_name": file_name, 
		"meta": {
			"mod_title": mod_title, 
			"mod_creator": mod_creator, 
			"mod_artist": mod_artist, 
			"song_artist": song_artist, 
			"song_title": song_title, 
			"length": length, 
		}, 
	})

	

func add_buttons_mod():
	if mods.size() < 1: return no_mods()
	for i in mods.size():
		appended_mods_obj = mods_obj.instance()
		appended_mods_obj.add_text(mods[i])
		appended_mods_obj.add_thumb(mods[i]["file_name"])
		$Buttons.add_child(appended_mods_obj)
		mods_buttons.append(appended_mods_obj)
		appended_mods_obj.position = Vector2(300, (100 * i) + 100)

	add_download_button()

	

func add_download_button():
	appended_mods_obj = download_obj.instance()
	$Buttons.add_child(appended_mods_obj)
	mods_buttons.append(appended_mods_obj)
	refresh_buttons()
	return appended_mods_obj



func no_mods():
	add_download_button().position = Vector2(300, (100) + 100)

func move_buttons(event):
	
	if event.is_action_pressed("ui_up"):
		scroll_time = 0.0
		last_scroll = 0.0
		mod_index = Util.value_cycle(mod_index, - 1, 0, mods_buttons.size() - 1)
		$ui_tick.play()

	
	if event.is_action_pressed("ui_down"):
		scroll_time = 0.0
		last_scroll = 0.0
		mod_index = Util.value_cycle(mod_index, 1, 0, mods_buttons.size() - 1)
		$ui_tick.play()

	refresh_buttons()


var scroll_speed = 0.15
var scroll_wait = 6.0
var scroll_time = 0.0
var last_scroll = 0.0
func _process(_delta):
	
	if mods.size() < 1: return
	if Input.is_action_pressed("ui_up"):
		scroll_time += scroll_speed
		if scroll_time > scroll_wait:
			if floor(scroll_time) != floor(last_scroll):
				mod_index = Util.value_cycle(mod_index, - 1, 0, mods_buttons.size() - 1)
				$ui_tick.play()
				refresh_buttons()
				last_scroll = scroll_time
		
	
	if Input.is_action_pressed("ui_down"):
		scroll_time += scroll_speed
		if scroll_time > scroll_wait:
			if floor(scroll_time) != floor(last_scroll):
				mod_index = Util.value_cycle(mod_index, 1, 0, mods_buttons.size() - 1)
				$ui_tick.play()
				refresh_buttons()
				last_scroll = scroll_time



		
		

	
	

func _input(event):
	if Game.menu_state == Game.MENU.INACTIVE: return

	move_buttons(event)

	if event.is_action_pressed("game_quarter"):
		Game.menu_state = Game.MENU.INACTIVE
		$ui_back.play()
		Anims.fade_and_load_scene($Overlay / Fade, $Overlay / Fade / Tween, "res://01_scenes/01_Menu/Menu.tscn")
		Anims.fade_music($Music, $Music / Tween, "fade_out")

	elif event.is_action_pressed("game_half"):
		if mods.size() < 1: return Anims.fade_and_load_scene($Overlay / Fade, $Overlay / Fade / Tween, "res://01_scenes/07_Mod_Browser/mod_browser.tscn")
		Game.menu_state = Game.MENU.INACTIVE
		$ui_accept.play()
		if mod_index >= mods_buttons.size() - 1: return Anims.fade_and_load_scene($Overlay / Fade, $Overlay / Fade / Tween, "res://01_scenes/07_Mod_Browser/mod_browser.tscn")
		load_level("game")

	elif event.is_action_pressed("debug"):
		if mods.size() < 1: return
		Game.menu_state = Game.MENU.INACTIVE
		if mod_index >= mods_buttons.size() - 1: return
		$ui_accept.play()
		load_level("gallery")



func load_level(destination):
	Game.active_level = mods[mod_index]["file_name"]
	Game.target_directory = "mods"
	
	if destination == "game":
		Anims.fade_and_load_scene($Overlay / Fade, $Overlay / Fade / Tween, "res://01_scenes/02_Game/Game.tscn")
	elif destination == "gallery":
		Anims.fade_and_load_scene($Overlay / Fade, $Overlay / Fade / Tween, "res://01_scenes/08_Gallery/Gallery.tscn")

	Anims.fade_music($Music, $Music / Tween, "fade_out")


func refresh_buttons():
	for i in mods_buttons.size():

		var new_pos = offset(i, mod_index)
		mods_buttons[i].modulate = Color(0.5, 0.5, 0.5, 0.8)
		mods_buttons[i].z_index = 0
		
		$Buttons / Tween.interpolate_property(
			mods_buttons[i], 
			"position", 
			mods_buttons[i].position, 
			new_pos, 
			0.3, 
			Tween.TRANS_EXPO, 
			Tween.EASE_OUT
		)
		$Buttons / Tween.start()

	mods_buttons[mod_index].modulate = Color(1, 1, 1, 1)
	mods_buttons[mod_index].z_index = 1


func offset(step, selected):

	var offset_x

	var space_y = step * 90
	var selected_y = selected * - 90

	offset_x = 80 if step == selected else 200
	
	var sum = space_y + selected_y

	return Vector2(300 + offset_x, 200 + sum)





