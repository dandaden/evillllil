extends Control

var menu_index = 0

enum BUTTON{PLAY, OPTIONS, MODS, PATREON, CREDITS, QUIT}
onready var labels = [
	$CenterContainer / menu_labels / VBoxContainer / menu_play, 
	$CenterContainer / menu_labels / VBoxContainer / menu_options, 
	$CenterContainer / menu_labels / VBoxContainer / menu_mods, 
	$CenterContainer / menu_labels / VBoxContainer / menu_patreon, 
	$CenterContainer / menu_labels / VBoxContainer / menu_credits, 
	$CenterContainer / menu_labels / VBoxContainer / menu_quit
]

func _ready():

	for n in range(0, labels.size()):
		labels[n].modulate = Color(1, 1, 1, 0.3)
	labels[menu_index].modulate = Color(1, 1, 1, 1)


func shift_label(event):
	
	if event.is_action_pressed("ui_up"):
		menu_index = Util.value_cycle(menu_index, - 1, 0, labels.size() - 1)
		get_parent().play_ui_sound(2)

	
	if event.is_action_pressed("ui_down"):
		menu_index = Util.value_cycle(menu_index, 1, 0, labels.size() - 1)
		get_parent().play_ui_sound(3)
			
	
	var labelSelectedCol = {
		"selected": Color(1, 1, 1, 1), 
		"unselected": Color(0.5, 0.5, 0.5, 0.8)
	}
	
	
	for n in range(0, labels.size()):
		labels[n].modulate = labelSelectedCol.unselected
		
	
	labels[menu_index].modulate = labelSelectedCol.selected

func check_option():
	match menu_index:

		BUTTON.PLAY:
			Game.menu_state = Game.MENU.LEVELS
			get_parent().play_ui_sound(0)

		BUTTON.OPTIONS:
			Game.menu_state = Game.MENU.OPTIONS
			get_parent().play_ui_sound(0)

		BUTTON.MODS:
			get_parent().play_ui_sound(0)
			get_parent().fade_out()
			Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/01_Menu/Mod.tscn")

		BUTTON.PATREON:
			get_parent().play_ui_sound(1)
			get_parent().fade_out()
			Util.open_url("https://patreon.com/komdog")
		
		BUTTON.CREDITS:
			get_parent().play_ui_sound(0)
			Anims.fade_and_load_scene($Fade, $Fade / Tween, "res://01_scenes/05_Credits/Credits.tscn")
				
		BUTTON.QUIT:
			get_tree().quit()





