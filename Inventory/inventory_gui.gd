extends Control

var inventory : Inventory

@onready var margin : MarginContainer = $NinePatchRect/MarginContainer
@onready var grid: GridContainer = $NinePatchRect/MarginContainer/ScrollContainer/GridContainer
@onready var slots: Array[Slot] = []
var locked: bool = false

func _ready():
	inventory = Global.get_node("Inventory")
	connectSlots()
	inventory.updated.connect(update)
	update()
	
	var margin_value = 20
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)
	
func update():
	for i in range(slots.size()):
		var isg : ItemStackGUI = slots[i].itemStackGui
		isg.amount = inventory.slots[isg.item].amount
		isg.update()
		

func connectSlots():
	if not inventory.is_node_ready():
		await inventory.ready
	for i in range(GlobalScript.ALL_ITEMS.size()):
		var slot = preload("res://Inventory/slot.tscn").instantiate()
		grid.add_child(slot)
		slots.append(slot)
		var isg = preload("res://Inventory/item_stack_gui.tscn").instantiate()
		slot.insert(isg)
		isg.item = GlobalScript.ALL_ITEMS[i]
		if !isg.is_node_ready():
			await isg.ready
		isg.set_texture(isg.item.texture)
		isg.update()
				
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.button.pressed.connect(callable)
		
func onSlotClicked(slot: Slot):
	if locked: return
	if !GlobalScript.itemInHand:
		takeItemFromSlot(slot)
		return
		
func takeItemFromSlot(slot: Slot):
	await slot.takeItem()

func putItemBack():
	locked = true
	var targetSlot = slots.filter(func(slot): return slot.itemStackGui.item == GlobalScript.itemInHand.item)[0]
		
	var tween = create_tween()
	var targetPosition = targetSlot.global_position + targetSlot.size/2
	tween.tween_property(GlobalScript.itemInHand,"global_position", targetPosition, 0.2)
	
	await tween.finished
	insertItemInSlot()
	locked = false
	
func insertItemInSlot():
	inventory.insert(GlobalScript.itemInHand.item)
	GlobalScript.itemInHand.queue_free()
	GlobalScript.itemInHand = null
	update()
	
func _input(_event):
	if GlobalScript.itemInHand && !locked && Input.is_action_pressed("Right_click"):
		putItemBack()
