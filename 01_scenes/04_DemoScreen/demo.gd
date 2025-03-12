extends Control


func _ready():
	$Fade.visible = true
	$Fade / Tween.interpolate_property($Fade, 
	"color", Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Fade / Tween.start()
	$patreon_button / Tween.interpolate_property($patreon_button, 
	"modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$patreon_button / Tween.start()
	
func open_patreon():
	$ui_tick.play()
	if OS.shell_open("https://patreon.com/komdog") == OK:
		pass
	$patreon_button.focus_mode = Control.FOCUS_NONE
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		$ui_accept.play()
		$Fade / Tween.interpolate_property($Fade, 
		"color", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Fade / Tween.start()
		$patreon_button / Tween.interpolate_property($patreon_button, 
		"modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$patreon_button / Tween.start()
		$continue.start()
		
func continue_to_menu():
	Util.load_scene("res://01_scenes/01_Menu/Menu.tscn")
	
	
	
