extends VBoxContainer


func set_text(cmd: String, res: String) -> void :
	$typed_command.text = cmd
	$response.text = res
	
