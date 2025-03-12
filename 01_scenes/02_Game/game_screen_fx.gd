extends Node

var do_fx: bool

func run_fx(screen_flash):
	do_fx = screen_flash

	if do_fx == false: return

	
	$BreakFX / Tween.interpolate_property($BreakFX, 
	"color", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$BreakFX / Tween.start()

	
	$_hit / Tween.interpolate_property($_hit, 
	"modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$_hit / Tween.start()
	
	$_hit / Tween.interpolate_property($_hit, 
	"scale", Vector2(1, 1), Vector2(0.8, 0.8), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$_hit / Tween.start()

func end_flash():
	
	$BreakFX / Tween.interpolate_property($BreakFX, 
	"color", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$BreakFX / Tween.start()

func section_grade():
	if Game.section_notes_hit < Game.section_presses:
		$_hit.frame = 0
		Game.score += 500
	elif Game.section_notes_hit == Game.section_presses:
		$_hit.frame = 1
		Game.score += 1000
		if do_fx == false: return
		$BreakFX / SectionSound.play()

	Game.section_notes_hit = 0
	Game.section_presses = 0
