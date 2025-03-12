extends Node


func fade_in(obj, tween):
	tween.interpolate_property(obj, "color", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func fade_out(obj, tween):
	tween.interpolate_property(obj, "color", Color(0, 0, 0, 1), Color(0, 0, 0, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func flash(obj, tween):
	tween.interpolate_property(obj, "color", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func fade_and_load_scene(obj, tween, scene: String):
	Game.menu_state = Game.MENU.INACTIVE
	tween.interpolate_property(obj, "color", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().paused = false
	Util.load_scene(scene)

func fade_and_restart_scene(obj, tween):
	Game.menu_state = Game.MENU.INACTIVE
	tween.interpolate_property(obj, "color", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().paused = false
	Util.reload_scene()

func fade_music(obj, tween, type: String):
	var a
	var b

	if type == "fade_in":
		a = - 80
		b = 0
	elif type == "fade_out":
		a = 0
		b = - 80
		
	tween.interpolate_property(obj, "volume_db", a, b, 1.0)
	tween.start()
