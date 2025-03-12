extends Node


func load_scene(path):
	Util.log("Changed scene to " + path)
	return get_tree().change_scene(path)


func reload_scene():
	return get_tree().reload_current_scene()


func open_url(url):

	return OS.shell_open(url)

func remap(value, input_a, input_b, output_a, output_b):
	return (value - input_a) / (input_b - input_a) * (output_b - output_a) + output_a


static func log(string: String):
	var time = "%02d:%02d:%02d" % [OS.get_time().hour, OS.get_time().minute, OS.get_time().second]
	var log_string = "(%s) %s" % [time, string]
	print(log_string)


func json_print(object):
	var string = JSON.print(object, "	")
	print(string)

func last_in_array(index, array):
	return index == array.size() - 1

func value_cycle(value, delta, minimum, maximum):
	
	value += delta
	
	
	if value < minimum:
		value = maximum
	elif value > maximum:
		value = minimum

	return value

func load_ogg(path):
	
	var ogg_file = File.new()
	if ogg_file.open(path, File.READ) != OK: return Util.log("Cound not locate file: " + path)
	var bytes = ogg_file.get_buffer(ogg_file.get_len())
	var stream_data = AudioStreamOGGVorbis.new()
	stream_data.data = bytes
	ogg_file.close()
	
	return stream_data
	
func load_texture(path):
	var dir = Directory.new()
	if not dir.file_exists(path): return Util.log("No image found at %s" % path)
	
	var img = Image.new()
	img.load(path)

	var tex = ImageTexture.new()
	tex.create_from_image(img)
	return tex


func type(object):

	var types = [
		"TYPE_NIL", 
		"TYPE_BOOL", 
		"TYPE_INT", 
		"TYPE_REAL", 
		"TYPE_STRING", 
		"TYPE_VECTOR2", 
		"TYPE_RECT2", 
		"TYPE_VECTOR3", 
		"TYPE_TRANSFORM2D", 
		"TYPE_PLANE", 
		"TYPE_QUAT", 
		"TYPE_AABB", 
		"TYPE_BASIS", 
		"TYPE_TRANSFORM", 
		"TYPE_COLOR", 
		"TYPE_NODE_PATH", 
		"TYPE_RID", 
		"TYPE_OBJECT", 
		"TYPE_DICTIONARY", 
		"TYPE_ARRAY", 
		"TYPE_RAW_ARRAY", 
		"TYPE_INT_ARRAY", 
		"TYPE_REAL_ARRAY", 
		"TYPE_STRING_ARRAY", 
		"TYPE_VECTOR2_ARRAY", 
		"TYPE_VECTOR3_ARRAY", 
		"TYPE_COLOR_ARRAY", 
		"TYPE_MAX", 
	]
	
	var value = typeof(object)
	return types[value]
