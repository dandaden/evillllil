extends Control

const button_instance = preload("res://02_prefabs/OnlineModButton/OnlineModButton.tscn")
var button_object

var index = 0

var menu_index = 0
var menu_object_array = []
var menu_state

var thumbnail_array = []

var json
var mods = []

func _ready():
	$Label2.text = "Press %s to go back" % Keybinds.key_quarter_text
	$Label3.text = "Press %s to download mod" % Keybinds.key_half_text
	Anims.fade_music($Music, $Tween, "fade_in")
	Anims.fade_out($Fade, $Tween)
	menu_state = Game.MENU.MODS
	get_all_mods()

	
func get_all_mods():
	
	var api_url = "https://firebasestorage.googleapis.com/v0/b/bbmods/o/?delimiter=/"
	var http = HTTPRequest.new()
	http.connect("request_completed", self, "request_complete")
	add_child(http)
	if http.request(api_url) == OK:
		pass

func request_complete(_result, response_code, _headers, body):
	$Loading.visible = false

	if response_code != 200:
		print("Could not GET mods; Error Code: %s" % response_code)
		$NoModsText.text = "Could not GET mods; Error Code: %s" % response_code
		$NoModsText.visible = true
		return

	json = JSON.parse(body.get_string_from_utf8())
	load_mods()
	


func load_mods():
	mods = []

	if json.result == null:
		$NoModsText.text = "API URL ENDPOINT is incorrect"
		$NoModsText.visible = true
		return

	for item in json.result["prefixes"]:
		mods.append(item.trim_suffix("/"))

	
	if mods.size() < 1:
		$NoModsText.text = "No mods found in Database! :("
		$NoModsText.visible = true
		return

	print(mods)
	add_buttons()

func add_buttons():

	
	for i in range(0, mods.size()):
		button_object = button_instance.instance()
		$Buttons.add_child(button_object)
		button_object.rect_position = Vector2(64, (64) + (i * 140))
		button_object.set_text(mods[i])
		button_object.check_downloaded(mods[i])
		menu_object_array.append(button_object)

	print(menu_object_array)

	refresh_buttons()
	menu_state = Game.MENU.ACTIVE



func refresh_buttons():

	if menu_object_array.size() < 1: return

	for i in menu_object_array.size():
		var button_new_pos = offset(Vector2(64, 64), i, menu_index)
		$Tween.interpolate_property(
			menu_object_array[i], 
			"rect_position", 
			menu_object_array[i].rect_position, 
			button_new_pos, 
			0.3, 
			Tween.TRANS_EXPO, 
			Tween.EASE_OUT
		)
		$Tween.start()

		menu_object_array[i].modulate = Color(0.5, 0.5, 0.5, 1)
	menu_object_array[menu_index].modulate = Color(1, 1, 1, 1)
	$UiTick.play()


func offset(position, step, selected):
	
	var button_offset_x
	
	var button_space_y = (1 + step) * 90
	var button_selected_pos_y = selected * - 90
	
	button_offset_x = 0 if step == selected else 110
	
	var newPos = Vector2(position.x + (button_offset_x), position.y + (button_space_y + button_selected_pos_y))
	
	return newPos


func _input(event):
	if not event is InputEventKey: return
	if menu_state == Game.MENU.INACTIVE: return
	if event.is_action_pressed("ui_up"):
		menu_index = Util.value_cycle(menu_index, - 1, 0, menu_object_array.size() - 1)
		refresh_buttons()
	elif event.is_action_pressed("ui_down"):
		menu_index = Util.value_cycle(menu_index, 1, 0, menu_object_array.size() - 1)
		refresh_buttons()
	elif event.is_action_pressed("game_half"):
		if menu_object_array.size() < 1: return
		Vars.download_doc_id = mods[menu_index]
		print(mods[menu_index])
		Util.load_scene("res://01_scenes/06_Download/download_console.tscn")
	elif event.is_action_pressed("game_quarter"):
		$UiBack.play()
		Anims.fade_and_load_scene($Fade, $Tween, "res://01_scenes/01_Menu/Mod.tscn")
		Anims.fade_music($Music, $Tween, "fade_out")
		
	
	

