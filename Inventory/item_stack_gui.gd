extends Panel

class_name ItemStackGUI

@onready var itemSprite: Sprite2D = $Sprite
@onready var amountLabel: Label = $Label
var item: Item
var inventory: Inventory
var amount: int

const TARGET_SIZE = Vector2(16,16)

func _ready():
	inventory = Global.get_node("Inventory")
	if !inventory.is_node_ready():
		await inventory.ready

func _process(delta):
	amountLabel.visible = true if amount > 1 else false
	if itemSprite.texture:
		var current_size = itemSprite.texture.get_size()
		itemSprite.scale = TARGET_SIZE / current_size
	


#TODO: Potentiellement griser ici le sprite si on en a 0, et lock si on n'a pas débloqué
func update():
	var slot = inventory.slots[item]
	amount = slot.amount
	amountLabel.text = str(amount)
