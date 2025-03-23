extends Button
class_name Slot

@onready var backgroundSprite: Sprite2D = $Background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory : Inventory = Global.get_node("Inventory")
var itemStackGui: ItemStackGUI

func insert(isg: ItemStackGUI):
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)

func takeItem() -> ItemGUI:
	var inventorySlot = inventory.slots[itemStackGui.item]
	if inventorySlot.amount >= 1:
		inventorySlot.amount -=1
		var new_itemGUI = await GlobalScript.insertInHand(itemStackGui.item)
		itemStackGui.update()
		return new_itemGUI
	return null
