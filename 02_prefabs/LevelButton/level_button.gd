extends Sprite


func addText(character, i):

	if Game.loaded_level >= i:
		$BG.self_modulate = Color(1, 1, 1, 1)
		$Title.text = character
		$HighScore / Number.text = str(Game.high_scores[i])
	else:
		$BG.self_modulate = Color(0.2, 0.2, 0.2, 1)
		$Title.text = "Locked"
		$HighScore / Number.visible = false
		$HighScore.text = "Beat the previous level!"

func show_gallery():
	pass
	
