extends Sprite


onready var control = get_parent()


func _ready():
	print(control)
	$pulse.wait_time = 60 / 128
	



func _on_pulse_timeout():
	$Tween.interpolate_property(self, "scale", Vector2(1.1, 1.1), Vector2(1, 1), 1.0)
	$Tween.start()
