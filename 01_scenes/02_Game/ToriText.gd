extends Label

var char_num

func _set(property, value):
	if property == "visible_characters":
		if floor(value) == char_num: return
		char_num = floor(value)
		$Voice.stop()
		$Voice.play()
