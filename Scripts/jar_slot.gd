extends TextureButton
class_name JarSlot

var jar: Pot
var plant: Plant
var harvestable: bool = false
signal right_clicked

@onready var margin = $MarginContainer
@onready var potSprite = $MarginContainer/PotSprite
@onready var plantSprite = $MarginContainer/PlantSprite

func _ready() -> void:
	custom_minimum_size.y = custom_minimum_size.x * 2
	
	var margin_value = 20
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)
	
func _gui_input(event):
	if !GlobalScript.itemInHand && Input.is_action_pressed("Right_click"):
		right_clicked.emit()

func update_gui() :
	if jar:
		potSprite.texture = jar.texture if !harvestable else jar.texture_ready
		var current_size = potSprite.texture.get_size()
		# potSprite.scale = Vector2(120,120) / current_size
	else:
		potSprite.texture = null
	if plant:
		plantSprite.texture = plant.garden_texture
		var current_size = plantSprite.texture.get_size()
		# plantSprite.scale = Vector2(100,100) / current_size
	else:
		plantSprite.texture = null
