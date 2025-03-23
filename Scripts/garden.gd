extends Node

# A garden is a collection of jar slots.
# Each slot can contain a jar, and possibly a plant.
# There are several types of jars, each with different properties.
# Plants require a certain jar type to be placed in.
# Each plant has a growth time and can be harvested when fully grown.

const GARDEN_SLOTS = 10

var jar_slots: Array[JarSlot] = []
var jar1 = load("res://Inventory/Items/Pots/pot_tier1.tres")

# Initialize the garden with empty jar slots.
func _ready() -> void:
	for i in range(0, GARDEN_SLOTS):
		var jar_slot = JarSlot.new()
		jar_slot.jar = null
		jar_slot.plant = null
		add_child(jar_slot)
		jar_slots.append(jar_slot)
	print(jar_slots)

func handle_interraction(i):
	if(jar_slots[i].jar == null && GlobalScript.itemInHand.item.name == "pot_tier1"):
		jar_slots[i].jar = GlobalScript.itemInHand.item
		GlobalScript.itemInHand = null
		jar_slots[i].add_child(jar1)
	pass;

func call_interraction():
	if($slot1.pressed):
		handle_interraction(0)
	
	
