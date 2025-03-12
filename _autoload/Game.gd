extends Node


var exe_path = OS.get_executable_path().get_base_dir()
var debug_path = ProjectSettings.globalize_path("res://")
var cur_dir = exe_path + "/" if OS.is_debug_build() == false else debug_path


var character_directory: String
var target_directory: String


var autoplay = false
var debug_mode = false



enum MENU{
	ACTIVE = - 3
	DEBUG = - 2, 
	INACTIVE = - 1, 
	MAIN = 0, 
	OPTIONS = 1, 
	LEVELS = 2, 
	MODS = 3, 
	CREDITS = 4, 
	PAUSED = 5, 
	SCORE = 6, 
	GALLERY = 7

}
enum LEVEL{LAST = 3}
var menu_state
var menu_bpm = 60.0 / 128.0


var volume

var active = false
var active_level = ""
var active_level_name = ""
var active_level_index: int

var current_beat
var health
var score
var hit_notes
var total_presses
var section_notes_hit
var section_presses
var combo
var max_combo


var voice_interval = 0


var bar_position


var hit_perfect
var hit_great
var hit_good
var hit_wrong_note
var hit_miss


var high_scores: Array


var sec_per_beat: float
var song_pitch = 1


var free_note = false

enum NOTE_TYPE{NONE, HALF, QUARTER, EIGHTH}
var spawn_note_type


var seen_credits
var loaded_level
var levels = []

func load_save_data(config):
	if not config.has_section("save_data"): return Global.restore_defaults()
	loaded_level = config.get_value("save_data", "saved_level", 0)
	high_scores = config.get_value("save_data", "high_scores", get_level_count())
	if high_scores.size() != get_level_count().size():
		high_scores = get_level_count()

func get_level_count():
	var path = Game.cur_dir + "/Data/"
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)

	while true:
		var file = dir.get_next()
		if file == "":
			break
		else:
			if dir.file_exists(Game.cur_dir + "/Data/" + file + "/chart.cfg"):
				files.append(0)

	dir.list_dir_end()

	return files

func load_user_config(config):
	if not config.has_section("user_config"): return Global.restore_defaults()
	volume = config.get_value("user_config", "volume", 3)
	seen_credits = config.get_value("user_config", "seen_credits", false)


func restore_default_save_data(config):
	config.set_value("save_data", "saved_level", 0)

func restore_default_user_config(config):
	config.set_value("user_config", "volume", 3)
	config.set_value("user_config", "seen_credits", false)
