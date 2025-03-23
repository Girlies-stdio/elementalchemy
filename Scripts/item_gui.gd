extends Panel

class_name ItemGUI

@onready var itemSprite: Sprite2D = $Sprite
var item: Item

const TARGET_SIZE = Vector2(60,60)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta):
	if itemSprite.texture:
		var current_size = itemSprite.texture.get_size()
		itemSprite.scale = TARGET_SIZE / current_size
