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
	var inventorySlot = inventory.slots[itemStackGui.item]
	if inventorySlot.amount >= 1:
		inventorySlot.amount -=1
		var new_isg = ItemStackGUI.new()
		new_isg.amount = 1
		new_isg.amountLabel = "1"
		new_isg.item = itemStackGui.item
		new_isg.itemSprite = itemStackGui.itemSprite
		itemStackGui.update()
		return new_isg
	return null
