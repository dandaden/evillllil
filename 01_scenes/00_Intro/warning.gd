extends Control

onready var warning_text = $Text_Boxes / MarginContainer3 / VBoxContainer / MarginContainer / Label2
func _ready():
	warning_text.text = warning_text.text % Keybinds.key_half_text
	Anims.fade_out($Fade, $Fade / Tween)
func _input(event):
	if Game.menu_state == Game.MENU.INACTIVE: return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("game_half"):
		$ui_accept.play()
		Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/01_Menu/Menu.tscn")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
