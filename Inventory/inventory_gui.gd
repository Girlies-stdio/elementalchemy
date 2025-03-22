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
		var slot = Slot.new()
		$NinePatchRect/ScrollContainer/GridContainer.add_child(slot)
		
		slots.append(slot)
		var isg = preload("res://Inventory/item_stack_gui.tscn").instantiate()
		slot.add_child(isg)
		slot.itemStackGui = isg
		isg.item = GlobalScript.ALL_ITEMS[i]
		await isg.ready
		isg.itemSprite.set_texture(isg.item.texture)
		isg.update()
		
		slot.index = i #TODO: maybe remove index if not used
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
		
func onSlotClicked(slot):
	if locked: return
	if !GlobalScript.itemInHand:
		takeItemFromSlot(slot)
		return
		
func takeItemFromSlot(slot):
	GlobalScript.itemInHand = slot.takeItem()
	Global.add_child(GlobalScript.itemInHand)
	updateItemInHand()

func updateItemInHand():
	if !GlobalScript.itemInHand : return
	GlobalScript.itemInHand.global_position = get_global_mouse_position() - GlobalScript.itemInHand.size/2
	#TODO
	#itemInHand.update()
	
func putItemBack():
	locked = true
	var index = slots.filter(func(slot): return slot.itemStackGui.item == GlobalScript.itemInHand.item)[0]
		
	var targetSlot = slots[index]
	
	var tween = create_tween()
	var targetPosition = targetSlot.global_position + targetSlot.size/2
	tween.tween_property(GlobalScript.itemInHand,"global_position", targetPosition, 0.1)
	
	await tween.finished
	insertItemInSlot(targetSlot)
	locked = false
	
func insertItemInSlot(slot: Slot):
	inventory.insert(GlobalScript.itemInHand.item)
	slot.itemStackGui.update()
	GlobalScript.itemInHand = null
	
func _input(event):
	if GlobalScript.itemInHand && !locked && Input.is_action_pressed("Right_click"):
		putItemBack()
	updateItemInHand()
