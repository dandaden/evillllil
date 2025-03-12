extends Control

var index
var id
var title
var _thumb

const no_thumbnail_texture = preload("res://00_assets/textures/no_image.png")

const download_icon = preload("res://00_assets/textures/download.png")
const check_icon = preload("res://00_assets/textures/check.png")

func set_text(text):
	$Top / ModName.text = text

func check_downloaded(mod_name):
	var dir = Directory.new()
	if dir.dir_exists(Game.cur_dir + "/mods/" + mod_name):
		$Top / ColorRect / Icon.texture = check_icon
	else:
		$Top / ColorRect / Icon.texture = download_icon
