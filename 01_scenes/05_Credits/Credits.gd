extends Control
func _ready():
	Game.menu_state = Game.MENU.CREDITS
	$BackText.text = "Press %s to go back" % Keybinds.key_quarter_text
	$Music.play()
	Anims.fade_out($Fade, $Fade / Tween)

func _input(event):

	if event.is_action_pressed("game_quarter"):
		if Game.menu_state == Game.MENU.INACTIVE: return
		Game.menu_state = Game.MENU.INACTIVE
		$ui_back.play()
		Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/01_Menu/Menu.tscn")





