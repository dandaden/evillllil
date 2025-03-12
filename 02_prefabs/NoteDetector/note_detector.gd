extends AnimatedSprite

var current_note = null
var passed_note = null
var accuracy = ""

signal hitNote(type, accuracy)
signal missedNote()

func _physics_process(_delta):
	if Game.autoplay == true:
		if current_note != null:
			if current_note.position.x >= 300:
				check_note(current_note.input_type)


func _input(event):
	if get_tree().paused == true: return
	if not event is InputEventKey: return
	if Game.active == false: return
	if Game.autoplay == true: return
	
	if event.is_action_pressed("game_half"):
		do_bounce_anim()
		check_note("game_half")
	elif event.is_action_pressed("game_quarter"):
		do_bounce_anim()
		check_note("game_quarter")
	elif event.is_action_pressed("game_eighth"):
		do_bounce_anim()
		check_note("game_eighth")

func do_bounce_anim():
	$Tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.8, 0.8), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()


func check_note(note_type):

	Game.total_presses += 1
	Game.section_presses += 1
	
	if Game.autoplay == true: return auto_note(note_type)
	if Game.free_note == true: return use_free_note()
	if current_note == null: return bad_input()
	if current_note.has_been_hit == true: return bad_input()
	if current_note.input_type != note_type: return wrong_note()
	note_hit(note_type, accuracy)
			
func use_free_note():
	Game.free_note = false

func note_hit(note_type, get_accuracy):
	Game.hit_notes += 1
	Game.section_notes_hit += 1
	Game.combo += 1
	current_note.hide()
	current_note = null
	emit_signal("hitNote", note_type, get_accuracy)

func wrong_note():
	Game.hit_wrong_note += 1
	if passed_note != current_note:
		current_note.hide()
	current_note = null
	emit_signal("missedNote")
func bad_input():
	Game.hit_miss += 1
	emit_signal("missedNote")
		
func auto_note(note_type):
	note_hit(note_type, "perfect")

func set_current_note(area, accuracy_string):
	if not area.is_in_group("note"): return
	if area.has_been_hit == true: return
	current_note = area
	accuracy = accuracy_string



func _on_GoodArea_area_entered(area):
	set_current_note(area, "good")

func _on_GreatArea_area_entered(area):
	set_current_note(area, "great")

func _on_PrefectArea_area_entered(area):
	set_current_note(area, "perfect")


func _on_PrefectArea_area_exited(area):
	set_current_note(area, "great")
func _on_GreatArea_area_exited(area):
	set_current_note(area, "good")


func _on_MissArea_area_entered(area):
	if area.has_been_hit == true: return
	passed_note = area

	if passed_note.has_been_hit == false:
		emit_signal("missedNote")
		Game.hit_miss += 1
		passed_note.modulate = Color(0.2, 0, 0, 0.5)
		passed_note.has_been_hit = true

		

