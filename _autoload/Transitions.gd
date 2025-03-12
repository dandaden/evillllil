extends Node

enum TYPE{NORMAL, FINAL}

var animations: Dictionary
var effects: Dictionary
var backgrounds: Dictionary

var sound_fx: Dictionary
var transition_sounds: Dictionary
var voice_clips: Dictionary

var loaded_assets: Array


func valid(transition, key):
	
	if transition == null: return false
	if not transition.has(key): return false
	if transition[key] == null: return false
	
	if typeof(transition[key]) == TYPE_STRING:
		if not transition[key].is_valid_filename(): return false
	elif typeof(transition[key]) == TYPE_ARRAY:
		if transition[key].empty(): return false
	elif typeof(transition[key]) == TYPE_DICTIONARY:
		if transition[key].empty(): return false

	return true


func create_transition_objects(initial_data, transitions, last_transition):

	
	loaded_assets.clear()
	animations.clear()
	effects.clear()
	backgrounds.clear()
	sound_fx.clear()
	transition_sounds.clear()
	voice_clips.clear()


	
	load_images(animations, initial_data, "/anims/", "animation")
	load_background(backgrounds, initial_data, "/textures/", "background")
	load_sound(sound_fx, initial_data, "/sfx/", "sound_fx")
	get_voice_bank(voice_clips, initial_data, "/voice/", "voice_bank")

	for i in transitions:
		load_images(animations, transitions[i], "/anims/", "animation")
		load_images(effects, transitions[i], "/anims/fx/", "effects")
		load_background(backgrounds, transitions[i], "/textures/", "background")
		load_sound(sound_fx, transitions[i], "/sfx/", "sound_fx")
		load_sound(transition_sounds, transitions[i], "/sfx/", "transition_sound")
		get_voice_bank(voice_clips, transitions[i], "/voice/", "voice_bank")

	load_images(animations, last_transition, "/anims/", "animation")
	load_images(effects, last_transition, "/anims/fx/", "effects")
	load_background(backgrounds, last_transition, "/textures/", "background")
	load_sound(transition_sounds, last_transition, "/sfx/", "transition_sound")
	load_sound(transition_sounds, last_transition, "/sfx/", "climax_sound")



func load_images(dict, transition, path, key):
	if valid(transition, key):
		var name = transition[key]
		if loaded_assets.has(name): return
		loaded_assets.append(name)

		var texture = Util.load_texture(Game.character_directory + path + transition[key])
		dict[name] = texture

func load_sound(dict, transition, path, key):
	if valid(transition, key):
		var name = transition[key]
		if loaded_assets.has(name): return
		loaded_assets.append(name)

		var audio = Util.load_ogg(Game.character_directory + path + transition[key])
		dict[name] = audio


func load_background(dict, transition, path, key):
	if valid(transition, key):
		var name = transition[key][0]
		if loaded_assets.has(name): return
		loaded_assets.append(name)

		var texture = Util.load_texture(Game.character_directory + path + transition[key][0])
		dict[name] = texture

func get_voice_bank(dict, transition, path, key):
	if valid(transition, key):
		var name = transition[key]["name"]
		if loaded_assets.has(name): return
		loaded_assets.append(name)

		dict[name] = load_voice_clips(name, path)


func load_voice_clips(name, path):
	var voice_array = []
	var dir = Directory.new()
	if dir.open(Game.character_directory + path + name + "/") == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				voice_array.append(Util.load_ogg(Game.character_directory + path + name + "/" + file_name))
			file_name = dir.get_next()

		return voice_array
	else:
		Util.log("Couldn't load voice bank")