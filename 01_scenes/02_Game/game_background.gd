extends Sprite

const wave_material = preload("res://00_assets/materials/background.tres")

var static_bg: bool


func init(initial_data):

	if Transitions.valid(initial_data, "background"):
		texture = Transitions.backgrounds[initial_data["background"][0]]
		static_bg = initial_data["background"][1]["static"]

		material = wave_material if static_bg == false else null
		scale = Vector2(2.344, 3.13) if static_bg == false else Vector2(1, 1)

	else:
		material = wave_material
		scale = Vector2(2.344, 3.13)
		texture = load("res://00_assets/textures/level_pattern.png")
		print("No background found, Falling back to default")

func transition_bg(dict):
	if Transitions.valid(dict, "background"):
		texture = Transitions.backgrounds[dict["background"][0]]
	else:
		Util.log("Error loading background")

func pulse():
	if static_bg == true:
		material = null
		$Tween.interpolate_property(self, "scale", Vector2(1.2, 1.2), Vector2(1.0, 1.0), 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
	else:
		material = wave_material
		$Tween.interpolate_property(self, "scale", Vector2(3.444, 4.23), Vector2(2.344, 3.13), 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()








