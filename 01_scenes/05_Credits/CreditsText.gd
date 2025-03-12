extends Label


func _ready():
	$Tween.interpolate_property(
		self, 
		"modulate", 
		Color(1, 1, 1, 0), 
		Color(1, 1, 1, 1), 
		1.0, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	$Tween.start()

func _on_Start_timeout():
	$Tween.interpolate_property(
		self, 
		"rect_position", 
		Vector2(40, 380), 
		Vector2(40, - 1080), 
		26.0, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	$Tween.start()


