extends Node

signal paused()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Game.active == false: return
		get_tree().paused = not get_tree().paused
		Game.menu_state = Game.MENU.PAUSED
		emit_signal("paused")
