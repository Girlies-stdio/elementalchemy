extends Button
class_name Slot

@onready var backgroundSprite: Sprite2D = $Background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory : Inventory = Global.get_node("Inventory")
var itemStackGui: ItemStackGUI
var index: int

func insert(isg: ItemStackGUI):
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)
	#func not done yet

func takeItem() -> ItemStackGUI:
	print("slot.take item")
	var inventorySlot = inventory.slots[itemStackGui.item]
	if inventorySlot.amount >= 1:
		inventorySlot.amount -=1
		var new_isg = preload("res://Inventory/item_stack_gui.tscn").instantiate()
		#TODO: Voir qui doit être le parent de ce reuf
		#Global.add_child(new_isg)
		get_tree().current_scene.add_child(new_isg)
		print(get_tree().current_scene.name)
		new_isg.amount = 1
		if !new_isg.is_node_ready():
			await new_isg.ready
		new_isg.amountLabel.text = "1"
		new_isg.item = itemStackGui.item
		new_isg.itemSprite = itemStackGui.itemSprite
		itemStackGui.update()
		return new_isg
	return null
