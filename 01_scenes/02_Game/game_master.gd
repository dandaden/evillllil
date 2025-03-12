extends Node2D


var noteObj = preload("res://02_prefabs/Note/Note.tscn")
var new_noteObj


var particleScene = preload("res://02_prefabs/Particles/Particles.tscn")
var hit_particles

func _ready():

	Game.menu_state = Game.MENU.ACTIVE
	Game.active = true
	load_config()
	init_vars()
	init_hud()

	
	$ScreenFX / Fade / Tween.interpolate_property($ScreenFX / Fade, "color", Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1.0)
	$ScreenFX / Fade / Tween.start()

func _input(event):
	if Game.menu_state == Game.MENU.INACTIVE: return
	
	if Game.active == false:
		if event.is_action_pressed("ui_restart"):
			$SoundEffects / ui_accept.play()
			game_end_option("restart")
		elif event.is_action_pressed("ui_v"):
			$SoundEffects / ui_accept.play()
			game_end_option("exit")

	if Game.debug_mode == true:
		if event.is_action_pressed("ui_end"):
			game_end_option("score_screen")

	
func init_vars():
	Util.log("Initiliazing game data")
	
	Game.score = 0
	Game.health = 100
	
	Game.hit_perfect = 0
	Game.hit_great = 0
	Game.hit_good = 0
	Game.hit_wrong_note = 0
	Game.hit_miss = 0
	
	Game.hit_notes = 0
	Game.total_presses = 0
	Game.section_notes_hit = 0
	Game.section_presses = 0
	
	Game.combo = 0
	Game.max_combo = 0

func init_hud():
	if Game.autoplay == false:
		
		$HUD / Control.visible = true
		$HUD / Control / Score / Progress.value = Game.health
		
		$ScreenFX / Light.visible = true
	else:
		$HUD / Control.visible = false


	
func hide_hud():
	
	$HUD / Control.visible = false
	$ScreenFX / Light.visible = false


var currentChar
var difficulty
var sequenceData
var section


var level_name
var song_path
var loop_speed
var music_volume
var sfx_volume
var voice_volume
var bpm
var note_offset
var no_spawn
var bar_position
var half_spawn
var quarter_spawn
var eighth_spawn
var initial_data
var screen_flash
var game_over_sound
var transitions
var last_beat
var last_transition
var post_song_delay

func load_config():

	
	currentChar = Game.active_level
	
	
	section = Global.difficulty[Global.difficultyIndex]
	
	Util.log("----- Starting level '%s' on '%s'" % [currentChar, section])

	
	Util.log("Searching %s for cfg file" % Game.active_level)
	var game_data_dir = Game.cur_dir + Game.target_directory + "/" + Game.active_level
	Game.character_directory = game_data_dir
	var config = ConfigFile.new()
	var err = config.load(game_data_dir + "/chart.cfg")
	if err == OK:
		
		Game.active_level_name = config.get_value(section, "name", null)
		song_path = config.get_value(section, "song_path", null)
		loop_speed = config.get_value(section, "loop_speed", 1)
		music_volume = config.get_value(section, "music_volume", 0.0)
		sfx_volume = config.get_value(section, "sfx_volume", 0.0)
		voice_volume = config.get_value(section, "voice_volume", 0.0)
		bpm = config.get_value(section, "bpm", null)
		note_offset = config.get_value(section, "note_offset", 0.0)
		bar_position = config.get_value(section, "bar_position", 750)
		no_spawn = config.get_value(section, "no_spawn", [0])
		half_spawn = config.get_value(section, "half_spawn", [0])
		quarter_spawn = config.get_value(section, "quarter_spawn", [0])
		eighth_spawn = config.get_value(section, "eighth_spawn", [0])
		initial_data = config.get_value(section, "initial_data", null)
		screen_flash = config.get_value(section, "screen_flash", true)
		game_over_sound = config.get_value(section, "game_over_sound", null)
		transitions = config.get_value(section, "transitions", null)
		last_beat = config.get_value(section, "last_beat", [transitions.keys().back()])
		last_transition = config.get_value(section, "last_transition", transitions[transitions.keys().back()])
		post_song_delay = config.get_value(section, "post_song_delay", 5.0)
		Util.log("Found config file")
		Game.spawn_note_type = initial_data["note_type"]
	else:
		Util.log("Couldn't parse chart.cfg")

	
	loop_speed = loop_speed * Game.song_pitch

	
	Game.bar_position = bar_position
	$HUD / Control / Bar.position = Vector2(300, Game.bar_position)
	if $HUD / Control / Bar.position.y > 400:
		
		$HUD / Control / Score.rect_position.y = 24
		$HUD / Control / Bar / Accuracy_Text.position.y = - 60
		$HUD / Control / Bar / Combo.rect_position.y = - 100
	else:
		
		$HUD / Control / Score.rect_position.y = 734
		$HUD / Control / Bar / Accuracy_Text.position.y = 60
		$HUD / Control / Bar / Combo.rect_position.y = 80

	Transitions.create_transition_objects(initial_data, transitions, last_transition)
	
	$Background.init(initial_data)
	$Character.init(initial_data)
	$SoundEffects.init(initial_data, sfx_volume, voice_volume)
	
	$GameOver / GameOverSound.stream = Util.load_ogg(Game.character_directory + "/sfx/" + game_over_sound)
	
	$Music.load_song_data(song_path, bpm, note_offset, music_volume)

	
	

func _on_Music_beat(beat_pos):

	
	Game.current_beat = beat_pos

	var note_spawn_offset = 4
	var note_spawn_beat = beat_pos + note_spawn_offset

	if note_spawn_beat in half_spawn:
		Game.spawn_note_type = 1
	elif note_spawn_beat in quarter_spawn:
		Game.spawn_note_type = 2
	elif note_spawn_beat in eighth_spawn:
		Game.spawn_note_type = 3
	elif note_spawn_beat in no_spawn:
		Game.spawn_note_type = 0
	elif note_spawn_beat in last_beat:
		Game.spawn_note_type = 0

	spawn_note(note_spawn_beat)

	
	if beat_pos in last_beat:
		transition(last_transition, Transitions.TYPE.FINAL)
		$SoundEffects / ClimaxSound.play()
		Game.active = false
		roundEnd()
	elif beat_pos in transitions:
		transition(transitions[beat_pos], Transitions.TYPE.NORMAL)

func transition(dict, type):
	
	$Background.transition_bg(dict)
	$Character.transition_animation(dict)
	$Character.set_fx(dict, type, loop_speed)
	
	$SoundEffects.transition_sfx(dict, type)
	$SoundEffects.transition_voice(dict)
	
	$ScreenFX.run_fx(screen_flash)
	$ScreenFX.section_grade()
	animate_screen_pulse()

		

func spawn_note(pos):

	
	if Game.spawn_note_type == 1:
		if pos % 4 == 0:
			new_noteObj = noteObj.instance()
			new_noteObj.init(Game.NOTE_TYPE.HALF)
			$HUD / Control.add_child(new_noteObj)

	
	elif Game.spawn_note_type == 2:
		if pos % 2 == 0:
			new_noteObj = noteObj.instance()
			new_noteObj.init(Game.NOTE_TYPE.QUARTER)
			$HUD / Control.add_child(new_noteObj)

	
	elif Game.spawn_note_type == 3:
		new_noteObj = noteObj.instance()
		new_noteObj.init(Game.NOTE_TYPE.EIGHTH)
		$HUD / Control.add_child(new_noteObj)

	
	elif Game.spawn_note_type == 0:
		pass

var voice_toggle = true

func _on_Heart_hitNote(type, accuracy):
	$HUD / Control / Bar / Combo.text = "x%02d" % Game.combo
	if Game.combo >= 5:
		$HUD / Control / Bar / Combo.visible = true
		
	if Game.combo >= Game.max_combo:
		Game.max_combo = Game.combo

	$SoundEffects / LoopSound.play()

	
	if Game.voice_interval != 0:
		if Game.current_beat != null:
			if Game.current_beat % Game.voice_interval == 0:
				$SoundEffects.cycle_voice()
				$SoundEffects / VoiceSound.play()
	
	
	hit_particles = particleScene.instance()
	$HUD / Control / Bar / Heart.add_child(hit_particles)
	
	
	if accuracy == "good":
		$HUD / Control / Bar / Accuracy_Text.frame = 1
		Game.score += 10
		Game.hit_good += 1
	if accuracy == "great":
		$HUD / Control / Bar / Accuracy_Text.frame = 2
		Game.score += 50
		Game.hit_great += 1
	if accuracy == "perfect":
		$HUD / Control / Bar / Accuracy_Text.frame = 3
		Game.score += 100
		Game.hit_perfect += 1
		
	if Game.health < 100:
		Game.health += 5
	
	
	$HUD / Control / Score / Progress.value = Game.health
		
	
	if type == "game_half":
		$Character / Anim.playback_speed = loop_speed
	elif type == "game_quarter":
		$Character / Anim.playback_speed = loop_speed * 2
	elif type == "game_eighth":
		$Character / Anim.playback_speed = loop_speed * 4
	
	$Character.loop()

	animate_screen_pulse()

	
	$HUD / Control / Bar / Combo / Tween.interpolate_property($HUD / Control / Bar / Combo, 
	"rect_scale", Vector2(1.3, 1.3), Vector2(1, 1), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	$HUD / Control / Bar / Combo / Tween.start()
	
	$HUD / Control / Bar / Accuracy_Text / Tween.interpolate_property($HUD / Control / Bar / Accuracy_Text, 
	"scale", Vector2(1.3, 1.3), Vector2(1, 1), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	$HUD / Control / Bar / Accuracy_Text / Tween.start()


	var health_bar_color = float(Game.health) / 100.0
	$HUD / Control / Score / Progress.tint_progress = Color(1, health_bar_color, health_bar_color, 1)
	$HUD / Control / Score / Progress.value = Game.health

func animate_screen_pulse():
	$Background.pulse()
	
	$ScreenFX / Light / Tween.interpolate_property($ScreenFX / Light, 
	"color", Color(0, 0, 0, 0), Color(0, 0, 0, 0.4), 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$ScreenFX / Light / Tween.start()
	
	$Character / Tween.interpolate_property($Character, 
	"scale", Vector2(1.2, 1.2), Vector2(1.0, 1.0), 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Character / Tween.start()

func _on_Heart_missedNote():
	if Game.active == true:

		Game.combo = 0
		$HUD / Control / Bar / Combo.visible = false

		if Game.health > 10:
			Game.health -= 15
			$SoundEffects / ui_back.play()
		else:
			game_over()

		var health_bar_color = float(Game.health) / 100.0
		$HUD / Control / Score / Progress.tint_progress = Color(1, health_bar_color, health_bar_color, 1)
		$HUD / Control / Score / Progress.value = Game.health




var easter_egg = false
func game_over():
	Game.menu_state = Game.MENU.ACTIVE
	Game.active = false
	$Music.stop()
	hide_hud()

	check_easter_egg()
	if easter_egg == true: return easter_egg_game_over()

	$GameOver.visible = true
	$GameOver / GameOverSound.play()
	$ScreenFX.end_flash()

func check_easter_egg():
	if Game.active_level != "01_toriel": return
	if Game.hit_notes >= 1: return
	easter_egg = true
func easter_egg_game_over():
	Game.menu_state = Game.MENU.INACTIVE
	$EasterEgg.run()


func fade_out():
	
	$ScreenFX / Fade / Tween.interpolate_property($ScreenFX / Fade, 
	"color", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.0)
	$ScreenFX / Fade / Tween.start()

func progress_level():
	if Game.autoplay == true: return
	if Game.loaded_level < Game.active_level_index + 1:
		Game.loaded_level += 1
		Global.save_game()
		Util.log("Level progressed to %s" % Game.loaded_level)
		Util.log("Game data saved")

func debug_roundEnd():
	if Game.autoplay == true: return exit_to_menu()
	if Game.debug_mode == true: return Util.load_scene("res://01_scenes/03_ScoreScreen/ScoreScreen.tscn")

func roundEnd():
	hide_hud()
	progress_level()
	yield(get_tree().create_timer(post_song_delay), "timeout")
	if Game.autoplay == true: return game_end_option("exit")
	game_end_option("score_screen")
	


func game_end_option(event: String):
	if $EasterEgg / SadMusic.playing == true: Anims.fade_music($EasterEgg / SadMusic, $EasterEgg / SadMusic / Tween, "fade_out")
	match event:
		"score_screen":
			record_score()
			Anims.fade_and_load_scene($ScreenFX / Fade, $ScreenFX / Fade / Tween, "res://01_scenes/03_ScoreScreen/ScoreScreen.tscn")
		"restart":
			Anims.fade_and_restart_scene($ScreenFX / Fade, $ScreenFX / Fade / Tween)
		"exit":
			exit_to_menu()

func record_score():
	if Game.score > Game.high_scores[Game.active_level_index]:
		Game.high_scores[Game.active_level_index] = Game.score

func exit_to_menu():
	if Game.target_directory == "mods":
		Anims.fade_and_load_scene($ScreenFX / Fade, $ScreenFX / Fade / Tween, "res://01_scenes/01_Menu/Mod.tscn")
	else:
		Anims.fade_and_load_scene($ScreenFX / Fade, $ScreenFX / Fade / Tween, "res://01_scenes/01_Menu/Menu.tscn")
