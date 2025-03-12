extends Sprite



func init(initial_data):
	if Transitions.valid(initial_data, "animation"):
		texture = Transitions.animations[initial_data["animation"]]
		$Anim.get_animation("Pump").loop = initial_data["looping"]
		loop()
	else:
		Util.log("Error loading transition animation (intial_data)")

func transition_animation(dict):
	if Transitions.valid(dict, "animation"):
		texture = Transitions.animations[dict["animation"]]
		$Anim.get_animation("Pump").loop = dict["looping"]
		loop()
	else:
		Util.log("Error loading transition animation")
	

func set_fx(dict, type, loop_speed):
	if Transitions.valid(dict, "effects"):
		$Transition.texture = Transitions.effects[dict["effects"]]
		
		match type:
			Transitions.TYPE.NORMAL:
				configure_animation(loop_speed, 1.2, [3, 2], "loop_6")
			Transitions.TYPE.FINAL:
				$Anim.playback_speed = loop_speed * 2.0
				configure_animation(loop_speed, 0.5, [6, 4], "loop_24")
		

func configure_animation(loop_speed, transition_speed, frames, animation):
	
	$Transition / Anim.playback_speed = loop_speed * transition_speed
	$Transition.hframes = frames[0]
	$Transition.vframes = frames[1]
	$Transition / Anim.play(animation)
		
func loop():
	$Anim.stop()
	$Anim.play("Pump")
	

	
		
