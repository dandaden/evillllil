extends Control


func set_text(value):
	if value == "": return set_hidden()
	$Panel / Label.text = value

func set_tag(value, color):
	if value == "": return set_hidden()
	$Panel / Tag.text = value
	$Panel / Tag.modulate = color

func set_hidden():
	$Panel.visible = false

func animate_in():
	$Tween.interpolate_property(
		$Panel, 
		"rect_position", 
		Vector2(600, 0), 
		Vector2(0, 0), 
		4.0, 
		Tween.TRANS_EXPO, 
		Tween.EASE_OUT
	)
	$Tween.start()
	$Tween.interpolate_property(
		$Panel, 
		"modulate", 
		Color(1, 1, 1, 0), 
		Color(1, 1, 1, 1), 
		4.0, 
		Tween.TRANS_EXPO, 
		Tween.EASE_OUT
	)
	$Tween.start()
