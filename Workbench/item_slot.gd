extends TextureButton
class_name ItemSlot

signal right_clicked

# The item currently in this slot
var item : Item

func _gui_input(event):
	if !GlobalScript.itemInHand && Input.is_action_pressed("Right_click"):
		right_clicked.emit()
