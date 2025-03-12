extends AudioStreamPlayer

var song_position = 0.0
var song_position_beats = 0

var last_half_beat: float = 0.0
var applied_offset: float


signal beat(pos)

func load_song_data(song_path, bpm, note_offset, volume):
	applied_offset = note_offset
	volume_db = volume
	pitch_scale = Game.song_pitch
	stream = Util.load_ogg(Game.character_directory + "/songs/" + song_path)
	Game.sec_per_beat = 60.0 / bpm
	play_song()

func play_song():
	if Game.active == false: return
	var starting_delay: = (
		AudioServer.get_time_to_next_mix()
		+ AudioServer.get_output_latency()
		+ applied_offset
	)
	yield(get_tree().create_timer(starting_delay), "timeout")
	

	var count_down_note_delay = (Game.sec_per_beat * 0.5) * Game.song_pitch

	$Timer.wait_time = count_down_note_delay
	$Timer.start()


var wait_loops: int = 5

func _on_Timer_timeout():
	if Game.active == false: return
	wait_loops -= 1
	get_parent().spawn_note(wait_loops)
	if wait_loops > 0: return
	$Timer.stop()
	if get_tree().paused == true: return
	play()

	
func _on_paused():
	if playing: return stop()
	if get_tree().paused == true: return
	if song_position <= 0.0: return

	var saved_song_position = song_position
	play()
	seek(saved_song_position)

func _on_resume():
	_on_paused()

func _process(_delta):
		
	if playing:
		
		song_position = (
			get_playback_position()
			+ AudioServer.get_time_since_last_mix()
			- AudioServer.get_output_latency()
			+ applied_offset
		)

		var half_beat = int(song_position / (Game.sec_per_beat * 0.5))
		
		if half_beat > last_half_beat:
			if Game.active == false: return
			
			last_half_beat = half_beat
			emit_signal("beat", half_beat)
		
