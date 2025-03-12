extends Control

var editing: bool = false
var options_index: int = 0

var key_half = Keybinds.key_half_input
var key_quatrter = Keybinds.key_quarter_input
var key_eighth = Keybinds.key_eighth_input

onready var key_binds = [
	$HBoxContainer / keys / VBoxContainer / _keybind_h, 
	$HBoxContainer / keys / VBoxContainer / _keybind_q, 
	$HBoxContainer / keys / VBoxContainer / _keybind_e, 
	$Label_apply_changes
]

var actions = [
	"game_half", 
	"game_quarter", 
	"game_eighth"
]

var new_keys = [
	key_half, 
	key_quatrter, 
	key_eighth
]

func _ready():

	Global.load_game()
	refresh_keys()
	
	for n in range(0, key_binds.size()):
		key_binds[n].modulate = Color(1, 1, 1, 0.3)
	key_binds[options_index].modulate = Color(1, 1, 1, 1)


func handle_event(event):
	if not editing:
		shift_menu_option(event)
	if editing:
		await_new_key(event)

	$Overlay.visible = editing
		


func shift_menu_option(event):
	
	if event.is_action_pressed("ui_up"):
		options_index = options_index - 1 if options_index > 0 else key_binds.size() - 1
		get_parent().play_ui_sound(2)

	
	if event.is_action_pressed("ui_down"):
		options_index = options_index + 1 if options_index < key_binds.size() - 1 else 0
		get_parent().play_ui_sound(3)

	
	if event.is_action_pressed("game_half"):
		if key_binds[options_index] != $Label_apply_changes:
			editing = true
		else:
			apply_actions()
			$ui_apply.play()
			Game.menu_state = Game.MENU.MAIN
			Util.log("Applied setting")
		

	
	for n in range(0, key_binds.size()):
		key_binds[n].modulate = Color(1, 1, 1, 0.3)
	key_binds[options_index].modulate = Color(1, 1, 1, 1)

	if event.is_action_pressed("game_quarter"):
		
		Game.menu_state = Game.MENU.MAIN
		get_parent().play_ui_sound(4)

var new_event

func await_new_key(event):
	print("Awating key for %s" % actions[options_index])
	var key_pressed = event.get_scancode_with_modifiers()
	if not event.is_action_pressed("ui_accept"):
		if event is InputEventKey:
			if key_pressed < KEY_A: return print("Invalid Key")
			if key_pressed > KEY_Z: return print("Invalid Key")
			new_event = event
			$Overlay / CenterContainer / overlay_label.text = "Press any key...\n Press Enter to apply: %s" % new_event.as_text()
			print("Set action to %s" % new_event.as_text())
	else:
		append_key(new_event)

func append_key(applied_event):
	
	key_binds[options_index].text = applied_event.as_text()
	
	new_keys[options_index] = applied_event
	editing = false
	
func apply_actions():

	
	for i in range(0, new_keys.size()):
		InputMap.action_erase_events(actions[i])
		InputMap.action_add_event(actions[i], new_keys[i])
		key_binds[i].modulate = Color(1, 1, 1, 1)
		Global.config.set_value("keybinds", actions[i], new_keys[i].as_text())
	
	Global.config.save("user://user_data.cfg")
	
	Keybinds.refresh_keybinds()
	refresh_keys()

func refresh_keys():
	key_binds[0].text = Keybinds.key_half_text
	key_binds[1].text = Keybinds.key_quarter_text
	key_binds[2].text = Keybinds.key_eighth_text




	
