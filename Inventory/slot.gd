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

func takeItem() -> ItemGUI:
	print("slot.take item")
	var inventorySlot = inventory.slots[itemStackGui.item]
	if inventorySlot.amount >= 1:
		inventorySlot.amount -=1
		var new_itemGUI = preload("res://Scenes/item_gui.tscn").instantiate()
		#TODO: Voir qui doit être le parent de ce reuf
		get_tree().current_scene.add_child(new_itemGUI)
		print(get_tree().current_scene.name)
		if !new_itemGUI.is_node_ready():
			await new_itemGUI.ready
		new_itemGUI.item = itemStackGui.item
		new_itemGUI.itemSprite = itemStackGui.itemSprite
		itemStackGui.update()
		return new_itemGUI
	return null
