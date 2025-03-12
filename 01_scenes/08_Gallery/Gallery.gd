extends Control

var level_name
var sfx_volume
var voice_volume
var initial_data
var transitions
var last_transition

func _ready():
	print("-- Starting Gallery")
	Game.menu_state = Game.MENU.GALLERY
	Anims.fade_out($Fade, $Tween)
	read_chart()

func read_chart():

	var load_dir = Game.target_directory
	var level_dir = Game.active_level

	Game.character_directory = Game.cur_dir + load_dir + "/" + level_dir
	var config = ConfigFile.new()
	var err = config.load(Game.character_directory + "/chart.cfg")
	if err == OK:
		
		level_name = config.get_value("EASY", "name", null)
		sfx_volume = config.get_value("EASY", "sfx_volume", 0.0)
		voice_volume = config.get_value("EASY", "voice_volume", 0.0)
		initial_data = config.get_value("EASY", "initial_data", null)
		transitions = config.get_value("EASY", "transitions", [0])
		last_transition = config.get_value("EASY", "last_transition", null)

		Util.log("Found config file")
		
		Transitions.create_transition_objects(initial_data, transitions, last_transition)
		$Image.parse_transitions(initial_data, transitions, last_transition)

		$Image / Sound.volume_db = sfx_volume
		$Image / TransitionSound.volume_db = sfx_volume
		$Image / Voice.volume_db = voice_volume

	else:
		Util.log("Couldn't parse chart.cfg")

func _input(ev):
	if not ev is InputEventKey: return
	if Input.is_key_pressed(KEY_G):
		$Controls.visible = not $Controls.visible
	
	
