extends Label

func _ready():
	text = "none"
	visible = Game.debug_mode

		

func _process(_delta):
	if Game.debug_mode:
		text = (
		"Beat: %s" % Game.current_beat + 
		"\nScore: %s " % Game.score + 
		"\nCombo: %s" % Game.combo + 
		"\nMax Combo: %s" % Game.max_combo + 
		"\nHealth: %s" % Game.health + 
		"\nLevel: %s" % Game.active_level + 
		"\nPerfect: %s" % Game.hit_perfect + 
		"\nGreat: %s" % Game.hit_great + 
		"\nGood: %s" % Game.hit_good + 
		"\nMissInput: %s" % Game.hit_wrong_note + 
		"\nMiss: %s" % Game.hit_miss + 
		"\nHit Notes: %s" % Game.hit_notes + 
		"\nTotal Presses: %s" % Game.total_presses + 
		"\nSection Notes: %s" % Game.section_notes_hit + 
		"\nSection Presses: %s" % Game.section_presses + 
		"\nAutoplay: %s" % Game.autoplay + 
		"\nDifficulty: %s" % Global.difficulty[Global.difficultyIndex]
		)

