extends Control

var exe_path = OS.get_executable_path().get_base_dir()
var debug_path = "E:/dev"


var update_path = exe_path + "/" if OS.is_debug_build() == false else debug_path
var install_path = update_path + "/updater/"

var url = "https://firebasestorage.googleapis.com/v0/b/bunfan-db.appspot.com/o/?prefix=public/updater/"
var exec = ""

var downloaded_files = 0
var files = []

func _ready():
	print("Path: %s" % update_path)
	request_update()
	

func request_update():

	var dir = Directory.new()
	if dir.open(update_path) == OK:
		dir.make_dir("updater")

	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "done_request")
	if http.request(url) == OK:
		print("Requesting update...")
		

func done_request(_res, _code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	files = json.result["items"]
	print("Download %s files..." % files.size())
	for file in files:
		download_file(file)

func download_file(file):
	var file_name = file["name"].trim_prefix("public/updater/")
	if ".exe" in file_name:
		exec = file_name
		print(exec)

	
	var download_url = "https://firebasestorage.googleapis.com/v0/b/" + file["bucket"] + "/o/" + file["name"].replace("/", "%2F") + "?alt=media"

	var http = HTTPRequest.new()
	add_child(http)
	http.use_threads = true
	http.connect("request_completed", self, "got_file", [file])
	http.set_download_file(install_path + file_name)
	
	if http.request(download_url) == OK:
		pass


func got_file(_res, _code, _headers, _body, file):
	print("Succssfully Downloaded %s" % file["name"].trim_prefix("public/updater/"))
	downloaded_files += 1

	if downloaded_files == files.size():
		finished_downloading()
		


func finished_downloading():
	print("Finished Downloading")
	if OS.shell_open(install_path + exec) == OK: pass
	get_tree().quit()



