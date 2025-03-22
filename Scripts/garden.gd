extends Node

# A garden is a collection of jar slots.
# Each slot can contain a jar, and possibly a plant.
# There are several types of jars, each with different properties.
# Plants require a certain jar type to be placed in.
# Each plant has a growth time and can be harvested when fully grown.

const GARDEN_SLOTS = 8

var jar_slots: Array = []

# Initialize the garden with empty jar slots.
func _ready() -> void:
	for i in range(0, GARDEN_SLOTS):
		var jar_slot = JarSlot.new()
		add_child(jar_slot)
