extends Control


enum ACTION{QUIT, RETRY}

const sounds = [
	preload("res://00_assets/sfx/round_end/sigh.ogg"), 
	preload("res://00_assets/sfx/round_end/clap.ogg"), 
	preload("res://00_assets/sfx/round_end/cheer.ogg"), 
]

var grade: int
var grade_text = [
	["You Didn't Do Anything.", 40, sounds[0]], 
	["OOF", 140, sounds[0]], 
	["OK!", 110, sounds[1]], 
	["NICE!", 100, sounds[1]], 
	["GREAT!!", 80, sounds[1]], 
	["FLAWLESS!!!", 60, sounds[2]], 
]

onready var panel_labels = [
	$Values / Perfect / Label, 
	$Values / Good / Label, 
	$Values / Ok / Label, 
	$Values / Miss / Label, 
	$Values / MaxCombo / Label, 
	$Values / TotalScore / Label
]

var values = [
	Game.hit_perfect, 
	Game.hit_great, 
	Game.hit_good, 
	Game.hit_wrong_note + Game.hit_miss, 
	Game.max_combo, 
	Game.score
]

func _ready():
	Game.menu_state = Game.MENU.INACTIVE
	$Options / Continue.text = $Options / Continue.text % Keybinds.key_half_text
	$SongName / Label.text = "Stage : %s" % Game.active_level_name
	Anims.flash($Flash, $Flash / Tween)
	$Music.play()
	calculate_grade()
	run_animation()

func calculate_grade():
	Util.log("--- ROUND ENDED")
	Util.log("hit : %s" % Game.hit_notes)
	Util.log("total : %s" % Game.total_presses)
	Util.log("perfect : %s" % Game.hit_perfect)
	if Game.hit_notes == 0: return set_grade(0)
	if Game.hit_notes == null: return set_grade(0)
	if Game.total_presses == Game.hit_perfect: return set_grade(5)

	var accuracy = float(Game.hit_notes) / float(Game.total_presses)
	Util.log("accuracy : %s" % accuracy)

	if accuracy <= 0.6: return set_grade(1)
	if accuracy <= 0.8: return set_grade(2)
	if accuracy <= 0.9: return set_grade(3)
	if accuracy <= 1.0: return set_grade(4)


func set_grade(value):
	grade = value

	
func run_animation():
	yield(get_tree().create_timer(1), "timeout")
	for i in panel_labels.size():
		panel_labels[i].text = panel_labels[i].text % values[i]
		panel_labels[i].get_parent().visible = true
		$Tick.play()
		yield(get_tree().create_timer(0.1), "timeout")
	yield(get_tree().create_timer(2), "timeout")
	show_grade()
	yield(get_tree().create_timer(1.8), "timeout")
	Game.menu_state = Game.MENU.SCORE
	$Options.visible = true

func show_grade():
	Anims.flash($Flash, $Flash / Tween)
	$Impact.play()

	$Panel.visible = true

	$Grade / Label.text = grade_text[grade][0]
	$Grade / Label.get("custom_fonts/font").size = grade_text[grade][1]
	$GradeSound.stream = grade_text[grade][2]
	$Grade.visible = true
	$GradeSound.play()

	$GradeFX / Label.text = grade_text[grade][0]
	$GradeFX.visible = true
	$GradeFX / Tween.interpolate_property($GradeFX, "scale", Vector2(0.8, 0.8), Vector2(2, 2), 1.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$GradeFX / Tween.start()
	$GradeFX / Tween.interpolate_property($GradeFX, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 0), 1.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$GradeFX / Tween.start()
	


var song_pos = 0.0
var beat = 0.0
var last_beat

func _process(_delta):
	song_pos = ($Music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() + 0.01)

	beat = int(song_pos / (60.0 / 128.0)) % 2
	if beat != last_beat:
		last_beat = beat
		pulse()

func pulse():
	$Grade / Tween.interpolate_property($Grade, "scale", Vector2(0.8, 0.8), Vector2(0.85, 0.85), (60.0 / 128.0), Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Grade / Tween.start()


	


func _input(event):
	if Game.menu_state == Game.MENU.INACTIVE: return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("game_half"):
		$UiAccept.play()
		exit(ACTION.QUIT)
	if event.is_action_pressed("ui_restart"):
		$UiAccept.play()
		exit(ACTION.RETRY)

func exit(selected_action):
	Anims.fade_music($Music, $Music / Tween, "fade_out")
	if selected_action == ACTION.QUIT:
		if Game.active_level_index == Game.LEVEL.LAST: return check_for_credits()
		exit_to_main()
	if selected_action == ACTION.RETRY:
		Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/02_Game/Game.tscn")
	
func check_for_credits():
	if Game.target_directory == "mods": return exit_to_mods()
	if Game.seen_credits == true: return exit_to_main()

	Game.seen_credits = true
	Global.save_game()
	Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/05_Credits/Credits.tscn")

func exit_to_main():
	Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/01_Menu/Menu.tscn")

func exit_to_mods():
	Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/01_Menu/Mod.tscn")





