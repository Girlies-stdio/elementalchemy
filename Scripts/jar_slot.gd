extends TextureButton
class_name JarSlot

var jar: Jar
var plant: Plant

func _ready() -> void:
	custom_minimum_size.y = custom_minimum_size.x * 2
