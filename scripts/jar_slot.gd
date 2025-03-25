extends TextureButton
class_name JarSlot

var jar: Pot
var plant: Plant
var harvestable: bool = false
var locked: bool = false
signal right_clicked

@onready var margin = $MarginContainer
@onready var potSprite = $MarginContainer/PotSprite
@onready var plantSprite = $MarginContainer/PlantSprite

var timer: Timer

func _ready() -> void:
	custom_minimum_size.y = custom_minimum_size.x * 2
	
	var margin_value = 20
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)
	
func _gui_input(_event):
	if !GlobalScript.itemInHand && Input.is_action_pressed("Right_click"):
		right_clicked.emit()

func update_gui() :
	if jar:
		potSprite.texture = jar.texture if !harvestable else jar.texture_ready
	else:
		potSprite.texture = null
	if plant:
		plantSprite.texture = plant.garden_texture
	else:
		plantSprite.texture = null
