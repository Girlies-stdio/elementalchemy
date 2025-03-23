extends Node

# A garden is a collection of jar slots.
# Each slot can contain a jar, and possibly a plant.
# There are several types of jars, each with different properties.
# Plants require a certain jar type to be placed in.
# Each plant has a growth time and can be harvested when fully grown.

const GARDEN_SLOTS = 10

var jar_slots: Array[JarSlot] = []

# Initialize the garden with empty jar slots.
func _ready() -> void:
	for i in range(0, GARDEN_SLOTS):
		var jar_slot = JarSlot.new()
		jar_slot.jar = null
		jar_slot.plant = null
		add_child(jar_slot)
		jar_slots.append(jar_slot)
	
	$Pot1.visible = false;

func handle_interraction(i): 
	#TODO: remplacer pot_tier1 par tout les types de pots et faire apparaite le sprit correctement
	if(jar_slots[i].jar == null && GlobalScript.itemInHand.item.name == "pot_tier1"):
		jar_slots[i].jar = GlobalScript.itemInHand.item
		GlobalScript.itemInHand.queue_free()
		GlobalScript.itemInHand = null
		$"../../../../Panel/InventoryGUI".updateItemInHand()
		#TODO:trouver comment afficher proprement les items, la cest en shlag
		$Pot1.visible = true

	


func _on_slot_1_pressed() -> void:
	handle_interraction(0)


func _on_slot_2_pressed() -> void:
	pass # Replace with function body.


func _on_slot_3_pressed() -> void:
	pass # Replace with function body.


func _on_slot_4_pressed() -> void:
	pass # Replace with function body.


func _on_slot_5_pressed() -> void:
	pass # Replace with function body.


func _on_slot_6_pressed() -> void:
	pass # Replace with function body.


func _on_slot_7_pressed() -> void:
	pass # Replace with function body.


func _on_slot_8_pressed() -> void:
	pass # Replace with function body.


func _on_slot_9_pressed() -> void:
	pass # Replace with function body.


func _on_slot_10_pressed() -> void:
	pass # Replace with function body.
