extends Node


var key_half_input
var key_quarter_input
var key_eighth_input

var key_half_text
var key_quarter_text
var key_eighth_text


func load_keybinds(config):
	if not config.has_section("keybinds"): return Global.restore_defaults()
	var binds = config.get_section_keys("keybinds")
	for bind in binds:
		var loaded_key = config.get_value("keybinds", bind)
		var bind_key = InputEventKey.new()
		bind_key.set_scancode(OS.find_scancode_from_string(loaded_key))
		InputMap.action_erase_events(bind)
		InputMap.action_add_event(bind, bind_key)

	
	key_half_input = InputMap.get_action_list("game_half")[0]
	key_quarter_input = InputMap.get_action_list("game_quarter")[0]
	key_eighth_input = InputMap.get_action_list("game_eighth")[0]

	key_half_text = InputMap.get_action_list("game_half")[0].as_text()
	key_quarter_text = InputMap.get_action_list("game_quarter")[0].as_text()
	key_eighth_text = InputMap.get_action_list("game_eighth")[0].as_text()

func restore_default_keybinds(config):
	
	if not config.has_section("keybinds"):
		Util.log("Loading Default Keybinds")
		config.set_value("keybinds", "game_half", "Z")
		config.set_value("keybinds", "game_quarter", "X")
		config.set_value("keybinds", "game_eighth", "C")

func refresh_keybinds():
	key_half_text = InputMap.get_action_list("game_half")[0].as_text()
	key_quarter_text = InputMap.get_action_list("game_quarter")[0].as_text()
	key_eighth_text = InputMap.get_action_list("game_eighth")[0].as_text()
	
