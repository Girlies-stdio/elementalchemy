extends TextureButton
class_name ItemSlot

signal right_clicked

# The item currently in this slot
var item : Item

@onready var margin = $MarginContainer
@onready var item_sprite = $MarginContainer/Item

func _ready():
	var margin_value = 10
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)

func _gui_input(_event):
	if !GlobalScript.itemInHand && Input.is_action_pressed("Right_click"):
		right_clicked.emit()
