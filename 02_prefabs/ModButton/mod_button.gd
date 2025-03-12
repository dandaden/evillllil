extends Sprite



func add_text(mod: Dictionary):
	var metadata = mod["meta"]
	$Title.text = metadata["mod_title"]
	$SongName.text = "%s - %s" % [metadata["song_artist"], metadata["song_title"]]

func add_thumb(file_name: String):
	print(file_name)
	$Thumb.texture = Util.load_texture(Game.cur_dir + "mods/" + file_name + "/thumb.png")

func no_thumb():
	$Thumb.texture = null


