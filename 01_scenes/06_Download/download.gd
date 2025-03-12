extends Control


onready var label = $Bg / MarginContainer / RichTextLabel

var query = Vars.download_doc_id

var total_assets = 0
var downloaded_assets = 0

func _ready():
	Game.menu_state = Game.MENU.INACTIVE
	$Failed / BackText.text = "Press %s to go back" % Keybinds.key_quarter_text
	$DownloadSound.play()
	append_text("-- Requesting Database")
	download_mod()

func append_text(text):
	label.text += "%s\n" % text


func download_mod():
	var api_url = "https://firebasestorage.googleapis.com/v0/b/bbmods/o/?prefix=%s/" % query
	var http = HTTPRequest.new()
	http.connect("request_completed", self, "request_complete")
	add_child(http)
	if http.request(api_url) == OK:
		pass


func make_mod_folder():
	var dir1 = Directory.new()
	if dir1.open(Game.cur_dir) == OK:
		dir1.make_dir(Game.cur_dir + "mods")

	var dir = Directory.new()
	if dir.open(Game.cur_dir + "mods/") == OK:
		if dir.dir_exists(Game.cur_dir + "mods/%s" % query):
			print("'%s' directory already exists" % query.to_upper())
			print("Overwriting Files...")
		else:
			print("Creating `%s` folder" % query)
			dir.make_dir(Game.cur_dir + "mods/%s/" % query)
			dir.make_dir(Game.cur_dir + "mods/%s/anims" % query)
			dir.make_dir(Game.cur_dir + "mods/%s/anims/fx" % query)
			dir.make_dir(Game.cur_dir + "mods/%s/sfx" % query)
			dir.make_dir(Game.cur_dir + "mods/%s/songs" % query)
			dir.make_dir(Game.cur_dir + "mods/%s/textures" % query)


func request_complete(_result, response_code, _headers, body):
	if response_code != 200: return download_failed("Error Code: %s" % response_code)
	var json = JSON.parse(body.get_string_from_utf8())
	var files = json.result["items"]
	total_assets = files.size()
	if total_assets < 1: return download_failed("NO_FILES_FOUND")
	make_mod_folder()
	print(total_assets)
	for file in files:
		print(file)
		download_file(file["name"])


func download_file(path):
	var download_url = "https://firebasestorage.googleapis.com/v0/b/bbmods/o/" + path.replace("/", "%2F") + "?alt=media"

	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "got_asset", [path])
	http.set_download_file(Game.cur_dir + "mods/" + path)

	if http.request(download_url) == OK:
		pass


func got_asset(_result, response_code, _headers, _body, file_name):
	var res_string = str(response_code) + " : Succesfully Downloaded " + str(file_name)
	print(res_string)
	append_text(res_string)
	downloaded_assets += 1
	if downloaded_assets == total_assets:
		download_finished()

func download_finished():
	print("Download Complete...")
	append_text("Download Complete...")
	label.visible = false
	$DownloadSound.stop()
	$CompleteSound.play()
	Anims.flash($Flash, $Tween)
	$Status.text = "Download Complete!"
	$Particles2D.emitting = true
	yield(get_tree().create_timer(2), "timeout")
	Util.load_scene("res://01_scenes/01_Menu/Mod.tscn")

func download_failed(error_code):
	$Failed.visible = true
	$Failed / Error.text = error_code
	$DownloadSound.stop()
	$FailedSound.play()
	$Status.text = "Download Failed!"
	Game.menu_state = Game.MENU.ACTIVE


func _input(event):
	if Game.menu_state == Game.MENU.INACTIVE: return
	if event.is_action_pressed("game_quarter"):
		Util.load_scene("res://01_scenes/07_Mod_Browser/mod_browser.tscn")

	


