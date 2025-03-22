extends Panel

class_name ItemGUI

@onready var itemSprite: Sprite2D = $Sprite
@onready var amountLabel: Label = $Label
var item: Item
var inventory: Inventory

const TARGET_SIZE = Vector2(16,16)

func _process(delta):
	if itemSprite.texture:
		var current_size = itemSprite.texture.get_size()
		itemSprite.scale = TARGET_SIZE / current_size
