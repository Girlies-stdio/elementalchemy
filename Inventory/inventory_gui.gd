extends Control

var inventory : Inventory

@onready var slots: Array[Slot] = []
var locked: bool = false

func _ready():
	inventory = Global.get_node("Inventory")
	connectSlots()
	inventory.updated.connect(update)
	update()
	
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
		$NinePatchRect/ScrollContainer/GridContainer.add_child(slot)
		slots.append(slot)
		var isg = preload("res://Inventory/item_stack_gui.tscn").instantiate()
		slot.insert(isg)
		isg.item = GlobalScript.ALL_ITEMS[i]
		if !isg.is_node_ready():
			await isg.ready
		isg.itemSprite.set_texture(isg.item.texture)
		isg.update()
				
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
		
func onSlotClicked(slot: Slot):
	if locked: return
	if !GlobalScript.itemInHand:
		takeItemFromSlot(slot)
		return
		
func takeItemFromSlot(slot: Slot):
	GlobalScript.itemInHand = await slot.takeItem()
	updateItemInHand()

func updateItemInHand():
	if !GlobalScript.itemInHand : return
	GlobalScript.itemInHand.global_position = get_global_mouse_position() - GlobalScript.itemInHand.size/2
	
func putItemBack():
	locked = true
	var targetSlot = slots.filter(func(slot): return slot.itemStackGui.item == GlobalScript.itemInHand.item)[0]
		
	var tween = create_tween()
	var targetPosition = targetSlot.global_position
	tween.tween_property(GlobalScript.itemInHand,"global_position", targetPosition, 0.2)
	
	await tween.finished
	insertItemInSlot(targetSlot)
	locked = false
	
func insertItemInSlot(slot: Slot):
	inventory.insert(GlobalScript.itemInHand.item)
	GlobalScript.itemInHand.queue_free()
	GlobalScript.itemInHand = null
	update()
	
func _input(event):
	if GlobalScript.itemInHand && !locked && Input.is_action_pressed("Right_click"):
		putItemBack()
	updateItemInHand()
