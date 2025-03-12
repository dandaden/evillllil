extends Area2D

var input_type = ""

var spawn_pos = Vector2(0, Game.bar_position)
var target_pos = Vector2(300, Game.bar_position)
var distance_to_target = target_pos.x - spawn_pos.x

var speed = 0

var has_been_hit = false

func _physics_process(delta):
	position.x += speed * delta * Game.song_pitch
	if position.x > 650:
		queue_free()
	
func init(type):
	speed = (distance_to_target / Game.sec_per_beat) / 2
	if type == Game.NOTE_TYPE.HALF:
		$note_visual.self_modulate = Color("#1a8dc7")
		$note_visual / note_label.text = Keybinds.key_half_text
		input_type = "game_half"
	elif type == Game.NOTE_TYPE.QUARTER:
		$note_visual.self_modulate = Color("#ed790c")
		$note_visual / note_label.text = Keybinds.key_quarter_text
		input_type = "game_quarter"
	elif type == Game.NOTE_TYPE.EIGHTH:
		$note_visual.self_modulate = Color("#c72b16")
		$note_visual / note_label.text = Keybinds.key_eighth_text
		input_type = "game_eighth"
	else:
		print("Invalid Arrow Type")
		return

	position.y = spawn_pos.y
	position.x = spawn_pos.x
	
func hide():
	visible = false
	has_been_hit = true
	
	
	
	
