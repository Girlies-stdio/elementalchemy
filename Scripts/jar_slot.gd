extends TextureButton
class_name JarSlot

var jar: Pot
var plant: Plant
var harvestable: bool = false
signal right_clicked

func _ready() -> void:
	custom_minimum_size.y = custom_minimum_size.x * 2
	
func _input(event):
	if !GlobalScript.itemInHand && Input.is_action_pressed("Right_click"):
		print("right click")
		right_clicked.emit()
