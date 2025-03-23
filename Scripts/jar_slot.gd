extends TextureButton
class_name JarSlot

var jar: Pot
var plant: Plant
var harvestable: bool = false

func _ready() -> void:
	custom_minimum_size.y = custom_minimum_size.x * 2
