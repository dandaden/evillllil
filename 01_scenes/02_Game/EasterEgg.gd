extends Control

var lines = [
	["That was fast.", 1.0], 
	["Are you kidding me???", 1.0], 
	["Get dunked on...", 1.0], 
	["Could you at least pretend \nlike you want to win?", 3.0], 
	["oh...", 3.0], 
	["Six times? really???", 1.4]
]

func run():

	OS.set_window_title("Undertale")

	var chosen_line_array = lines[Vars.easter_egg_line % lines.size()]

	var chosen_line = chosen_line_array[0]
	var line_time = chosen_line_array[1]

	Vars.easter_egg_line += 1

	$CenterContainer / ToriText.text = chosen_line
	visible = true
	$Break1.play()
	yield(get_tree().create_timer(1), "timeout")
	
	$Break2.play()
	$Heart.visible = false
	$Hearticles.emitting = true
	yield(get_tree().create_timer(2), "timeout")

	$GameOverText / Tween.interpolate_property($GameOverText, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0)
	$GameOverText / Tween.start()
	$SadMusic.play()

	yield(get_tree().create_timer(1), "timeout")
	load_dialogue(line_time)
	yield(get_tree().create_timer(line_time + 0.3), "timeout")
	$Options.visible = true
	Game.menu_state = Game.MENU.ACTIVE


func load_dialogue(line_time):
	var total_text = $CenterContainer / ToriText.get_total_character_count()
	
	$CenterContainer / ToriText / Tween.interpolate_property(
		$CenterContainer / ToriText, 
		"visible_characters", 
		0, 
		total_text, 
		line_time
	)
	$CenterContainer / ToriText / Tween.start()

	
