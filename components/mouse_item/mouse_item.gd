extends AspectRatioContainer
class_name MouseItem

func _input(_event):
	var offset = size / 2
	global_position = get_global_mouse_position() - offset
	
