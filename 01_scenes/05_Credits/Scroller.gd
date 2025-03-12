extends MarginContainer

onready var fade = get_node("../Fade")
onready var fade_tween = get_node("../Fade/Tween")

func _on_Start_timeout():
	$VBoxContainer.load_names()
	$Tween.interpolate_property(
		self, 
		"custom_constants/margin_top", 
		600, 
		- 900, 
		26.0, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	$Tween.start()

func _on_tween_completed(_object, _key):
	Anims.fade_and_load_scene(fade, fade_tween, "res://01_scenes/01_Menu/Menu.tscn")
