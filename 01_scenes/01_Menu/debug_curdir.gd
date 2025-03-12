extends Label

func _ready():
	visible = Game.debug_mode
	text = str(Game.cur_dir)
	


