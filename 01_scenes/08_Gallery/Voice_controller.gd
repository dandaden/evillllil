extends AudioStreamPlayer

var voice_index = 0
var voice_timing = 0
var last_rate = 0
var current_voice_bank = []
var climax_sound

func check_climax(img_index, transition_objects):
	if Util.last_in_array(img_index, transition_objects):
		stream = climax_sound
		play()

func increment(value):
	if last_rate == value:
		voice_timing += value
	else:
		voice_timing = 0
		last_rate = value

func play_voice(img_index, transition_objects):

	if current_voice_bank == null: return
	if current_voice_bank.empty(): return
	if transition_objects[img_index]["voice_interval"] == 0: return
	if transition_objects[img_index]["voice_interval"] == null: return

	voice_index += 1
	

	var rate = transition_objects[img_index]["voice_interval"]

	print(voice_timing)
	print(rate)

	if voice_timing % rate == 0:
		stream = current_voice_bank[voice_index % current_voice_bank.size()]
		play()