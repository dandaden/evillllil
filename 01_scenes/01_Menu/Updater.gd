extends HTTPRequest

var error
var link: String

func _ready() -> void :
	var url: String = "https://firestore.googleapis.com/v1/projects/bunfan-db/databases/(default)/documents/beat-banger/info"
	error = request(url)
	print("Checking for updates")

signal got_update(version)
func _on_Updater_request_completed(_result, responsecode, _headers, body):
	if responsecode != 200: return Util.log("Version GET request failed")
	var json = JSON.parse(body.get_string_from_utf8())
	link = json.result["fields"]["url"]["stringValue"]
	Vars.latest_release = json.result["fields"]["version"]["stringValue"]
	emit_signal("got_update", Vars.latest_release)

func _on_pressed():
	Util.open_url(link)
	
