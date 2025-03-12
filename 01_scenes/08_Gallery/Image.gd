extends Sprite




var img_index = 0

var speeds = [1, 2, 3, 4]
var speed_index = 1
var loop_speed = 1

var transition_objects = []
var loaded_transitions = []



func parse_transitions(initial_data, transitions, last_transition):


	
	make_transition(initial_data)
	for i in transitions: make_transition(transitions[i])
	make_transition(last_transition)

	set_initial()

	if Transitions.valid(last_transition, "climax_sound"):
		$Voice.climax_sound = Transitions.transition_sounds[last_transition["climax_sound"]]
	


func make_transition(dict):

	if loaded_transitions.has(dict["animation"]): return

	var animation = Transitions.animations[dict["animation"]] if Transitions.valid(dict, "animation") else null
	var effects = Transitions.effects[dict["effects"]] if Transitions.valid(dict, "effects") else null
	var transition_sound = Transitions.transition_sounds[dict["transition_sound"]] if Transitions.valid(dict, "transition_sound") else null
	var sound_fx = Transitions.sound_fx[dict["sound_fx"]] if Transitions.valid(dict, "sound_fx") else null
	var voice_clips = Transitions.voice_clips[dict["voice_bank"]["name"]] if Transitions.valid(dict, "voice_bank") else null
	var voice_interval = dict["voice_bank"]["interval"] if Transitions.valid(dict, "voice_bank") else null

	var object = {
		"animation": animation, 
		"effects": effects, 
		"transition_sound": transition_sound, 
		"sound_fx": sound_fx, 
		"voice_clips": voice_clips, 
		"voice_interval": voice_interval, 
	}
	transition_objects.append(object)
	loaded_transitions.append(dict["animation"])
	
	

func set_initial():
	texture = transition_objects[img_index]["animation"]
	$Sound.stream = transition_objects[img_index]["sound_fx"]
	$Voice.current_voice_bank = transition_objects[img_index]["voice_clips"]
	loop()

	
func change_loop(value):

	img_index = Util.value_cycle(img_index, value, 0, transition_objects.size() - 1)

	
	texture = transition_objects[img_index]["animation"]
	
	$Sound.stream = transition_objects[img_index]["sound_fx"]
	
	$TransitionSound.stream = transition_objects[img_index]["transition_sound"]
	$TransitionSound.play()
	
	$Effects.texture = transition_objects[img_index]["effects"]
	$Voice.current_voice_bank = transition_objects[img_index]["voice_clips"]
	$Voice.check_climax(img_index, transition_objects)
	run_fx()
	
	loop()





func set_speed(value):
	speed_index = Util.value_cycle(speed_index, value, 0, speeds.size() - 1)
	$Animation.playback_speed = speeds[speed_index] * loop_speed
	$Effects / Animation.playback_speed = speeds[speed_index]


enum {HALF, QUARTER, EIGHTH}
var last_input


func input_beat(speed):

	if Util.last_in_array(img_index, transition_objects): return

	speed_index = speed
	set_speed(0)

	$Voice.play_voice(img_index, transition_objects)
	$Animation.get_animation("Loop").loop = false
	loop()


func loop():
	
	if img_index == transition_objects.size() - 1:
		$Animation.stop()
		$Animation.play("Loop_Cum")
	else:
		$Animation.stop()
		$Animation.play("Loop")


func run_fx():
	if img_index == transition_objects.size() - 1:
		setup_transition(6, 4, "Cum")
	else:
		setup_transition(3, 2, "FX")

func setup_transition(hframes, vframes, animation):
	
	$Effects.hframes = hframes
	$Effects.vframes = vframes
	$Effects / Animation.playback_speed = 2
	$Effects / Animation.stop()
	$Effects / Animation.play(animation)


func _input(event):
	if Game.menu_state == Game.MENU.INACTIVE: return
	
	
	if event.is_action_pressed("ui_right"):
		change_loop(1)
	elif event.is_action_pressed("ui_left"):
		change_loop( - 1)
	elif event.is_action_pressed("ui_up"):
		set_speed(1)
	elif event.is_action_pressed("ui_down"):
		set_speed( - 1)
	elif event.is_action_pressed("ui_v"):
		loop_speed = Util.value_cycle(loop_speed, - 0.1, 0, 3)
		set_speed(0)
	elif event.is_action_pressed("ui_b"):
		loop_speed = Util.value_cycle(loop_speed, 0.1, 0, 3)
		set_speed(0)

	
	if event.is_action_pressed("ui_accept"):
		if $Animation.current_animation != "":
			$Animation.stop()
		else:
			$Animation.get_animation("Loop").loop = true
			loop()

	
	if event.is_action_pressed("game_half"):
		$Voice.increment(4)
		input_beat(0)
	elif event.is_action_pressed("game_quarter"):
		$Voice.increment(2)
		input_beat(1)
	elif event.is_action_pressed("game_eighth"):
		$Voice.increment(1)
		input_beat(3)


	if event.is_action_pressed("debug"):
		Game.menu_state = Game.MENU.INACTIVE
		var fade = get_parent().get_node("Fade")
		var tween = get_parent().get_node("Tween")
		$Back.play()
		if Game.target_directory == "data":
			Anims.fade_and_load_scene(fade, tween, "res://01_scenes/01_Menu/Menu.tscn")
		elif Game.target_directory == "mods":
			Anims.fade_and_load_scene(fade, tween, "res://01_scenes/01_Menu/Mod.tscn")

