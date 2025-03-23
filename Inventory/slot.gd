extends TextureButton
class_name Slot

@onready var backgroundSprite: Sprite2D = $Background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory : Inventory = Global.get_node("Inventory")
var itemStackGui: ItemStackGUI

func insert(isg: ItemStackGUI):
	itemStackGui = isg
	container.add_child(itemStackGui)

func takeItem() -> ItemGUI:
	if inventory.remove(itemStackGui.item):
		var new_itemGUI = await GlobalScript.insertInHand(itemStackGui.item)
		itemStackGui.update()
		return new_itemGUI
	return null
