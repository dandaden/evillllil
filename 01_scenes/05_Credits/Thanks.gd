extends Label


func _on_Timer_timeout():
	$Tween.interpolate_property(
		self, 
		"modulate", 
		Color(1, 1, 1, 0), 
		Color(1, 1, 1, 1), 
		5.0, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	$Tween.start()

