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
		var jar_slot = $JarSlot if i == 0 else get_node("JarSlot" + str(i + 1))
		jar_slot.jar = null
		jar_slot.plant = null
		jar_slots.append(jar_slot)
		jar_slot.connect("pressed", func() -> void : handle_interaction(jar_slot))

	
func handle_interaction(jar_slot: JarSlot): 
	var iih : ItemGUI = GlobalScript.itemInHand
	
	#cases : no item in hand and plant ready to collect -> add to inventory
	# no item in hand and empty pot in slot -> put back pot in hand
	if !iih:
		if jar_slot.jar && !jar_slot.plant:
			#put jar in hand
			GlobalScript.insertInHand(jar_slot.jar)
			jar_slot.jar = null
		elif jar_slot.jar && jar_slot.plant:
			#if grown, harvest
			if jar_slot.get_node("CenterContainer/PotSprite").texture == jar_slot.jar.texture_ready:
				print("harvesting")
				#TODO: edit this with the actual thing we want to insert
				Global.get_node("Inventory").insert(jar_slot.plant, 5)
				jar_slot.jar = null
				jar_slot.plant = null
	else:
		if jar_slot.jar && !jar_slot.plant && iih.item is Plant:
			if jar_slot.jar.type_plant == iih.item.type_plant:
				#insert plant in slot, then start timer
				jar_slot.plant = iih.item
				GlobalScript.itemInHand.queue_free()
				GlobalScript.itemInHand = null
				get_tree().create_timer(jar_slot.plant.nb_cycle).connect("timeout",func() -> void: 
					jar_slot.harvestable = true
					updateGUI())
			else: 
				#back in inventory
				#We simulate a right click to have the animation that takes the item back in its slot from the Inventory GUI
				Input.action_press("Right_click")
				await get_tree().create_timer(0.1).timeout
				Input.action_release("Right_click")
			
		elif !jar_slot.jar && !jar_slot.plant && iih.item is Pot:
			#insert jar in slot
			jar_slot.jar = iih.item
			GlobalScript.itemInHand.queue_free()
			GlobalScript.itemInHand = null
	updateGUI()
	
			
func updateGUI():
	#TODO: handle ready pots
	#TODO: center textures correctly
	for slot in jar_slots:
		var potSprite = slot.get_node("CenterContainer/PotSprite")
		var plantSprite = slot.get_node("CenterContainer/PlantSprite")
		if slot.jar:
			potSprite = slot.get_node("CenterContainer/PotSprite")
			potSprite.texture = slot.jar.texture if !slot.harvestable else slot.jar.texture_ready
			var current_size = potSprite.texture.get_size()
			potSprite.scale = Vector2(120,120) / current_size
		else:
			potSprite.texture = null
		if slot.plant:
			plantSprite = slot.get_node("CenterContainer/PlantSprite")
			plantSprite.texture = slot.plant.garden_texture
			var current_size = plantSprite.texture.get_size()
			plantSprite.scale = Vector2(100,100) / current_size
		else:
			plantSprite.texture = null
	
