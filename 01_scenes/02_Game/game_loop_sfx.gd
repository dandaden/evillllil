extends Node


func init(initial_data, sfx_volume, voice_volume):
	if Transitions.valid(initial_data, "sound_fx"):
		$LoopSound.stream = Transitions.sound_fx[initial_data["sound_fx"]]
	elif Transitions.valid(initial_data, "sound"):
		$LoopSound.stream = Transitions.sound_fx[initial_data["sound"]]
	else:
		Util.log("Error loading loop sound fx (initial_data)")

	
	$TransitionSound.volume_db = sfx_volume
	$LoopSound.volume_db = sfx_volume
	$VoiceSound.volume_db = voice_volume
	$ClimaxSound.volume_db = voice_volume

	transition_voice(initial_data)

func transition_sfx(dict, type):

	
	if not Transitions.valid(dict, "transition_sound"): return Util.log("Error loading transition sound fx")
	$TransitionSound.stream = Transitions.transition_sounds[dict["transition_sound"]]
	$TransitionSound.play()
	
	
	match type:
		Transitions.TYPE.NORMAL:
			if Transitions.valid(dict, "sound_fx"):
				$LoopSound.stream = Transitions.sound_fx[dict["sound_fx"]]
			elif Transitions.valid(dict, "sound"):
				$LoopSound.stream = Transitions.sound_fx[dict["sound"]]
		Transitions.TYPE.FINAL:
			if not Transitions.valid(dict, "climax_sound"): return Util.log("Error loading climax sound fx")
			$TransitionSound.stream = Transitions.transition_sounds[dict["climax_sound"]]
			$TransitionSound.play()

var current_voice_bank: Array
func transition_voice(dict):
	if Transitions.valid(dict, "voice_bank"):
		Game.voice_interval = dict["voice_bank"]["interval"]
		current_voice_bank = Transitions.voice_clips[dict["voice_bank"]["name"]]
	else:
		Game.voice_interval = 0
		return Util.log("No voice bank found")

var voice_index = 0
func cycle_voice():
	if current_voice_bank.empty(): return
	voice_index += 1
	$VoiceSound.stream = current_voice_bank[voice_index % current_voice_bank.size()]
		
