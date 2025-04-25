extends GridContainer

# A garden is a collection of jar slots.
# Each slot can contain a jar, and possibly a plant.
# There are several types of jars, each with different properties.
# Plants require a certain jar type to be placed in.
# Each plant has a growth time and can be harvested when fully grown.

const GARDEN_SLOTS = 10

var jar_slots: Array[JarSlot] = []

signal play_plant
signal play_cave
signal play_crystal
signal play_endgame

var sound_signals = [play_plant, play_cave, play_crystal, play_endgame]

signal putItemBack

# Initialize the garden with empty jar slots.
func _ready() -> void:
	var jar1 = GlobalScript.ALL_ITEMS[0]
	for i in range(0, GARDEN_SLOTS):
		var jar_slot : JarSlot = $JarSlot if i == 0 else get_node("JarSlot" + str(i + 1))
		jar_slot.jar = null
		jar_slot.plant = null
		jar_slots.append(jar_slot)
		jar_slot.connect("pressed", func() -> void : handle_interaction(jar_slot))
		jar_slot.connect("right_clicked", func() -> void : handleRightClick(jar_slot))
		if i < 4:
			jar_slot.locked = true
			jar_slot.jar = jar1
			jar_slot.plant = GlobalScript.ALL_ITEMS[i + 4]
			timer(jar_slot)
		updateGUI()

#Handles every type of interaction when clicking on a slot
func handle_interaction(jar_slot: JarSlot): 
	var iih : ItemGUI = GlobalScript.itemInHand
	
	#If no item in hand, either collect plant or take jar
	if !iih:
		if jar_slot.jar && !jar_slot.plant:
			#put jar in hand
			GlobalScript.insertInHand(jar_slot.jar)
			GlobalScript.itemInHand.global_position = get_global_mouse_position()

			jar_slot.jar = null
		elif jar_slot.jar && jar_slot.plant:
			#if grown, harvest
			if jar_slot.harvestable:
				GlobalScript.insertInHand(jar_slot.plant)
				GlobalScript.itemInHand.global_position = get_global_mouse_position()
				putItemBack.emit()
				timer(jar_slot)
				jar_slot.harvestable = false
	#If item in hand, either put it in a jar or swap items
	else:
		#insert plant in slot if correct tier, then start timer. Else put plant back in inventory
		if jar_slot.jar && !jar_slot.plant && iih.item is Plant:
			if jar_slot.jar.type_plant == iih.item.type_plant:
				jar_slot.plant = iih.item
				iih.queue_free()
				GlobalScript.itemInHand = null
				timer(jar_slot)
			else: 
				#back in inventory
				putItemBack.emit()
		#Swap plants in pot
		elif !jar_slot.locked && jar_slot.jar && jar_slot.plant && iih.item is Plant:
			if jar_slot.jar.type_plant == iih.item.type_plant:
				#First check growth stage
				if jar_slot.harvestable:
					GlobalInventory.insert(jar_slot.plant)
					jar_slot.harvestable = false
				var temp_item: Item = jar_slot.plant
				jar_slot.plant = iih.item
				if jar_slot.timer:
					jar_slot.timer.queue_free()
				timer(jar_slot)
				GlobalScript.itemInHand.item = temp_item
				GlobalScript.itemInHand.set_texture(temp_item.texture)
		
		#If holding pot, either insert it or swap
		elif iih.item is Pot:
			#Empty slot case
			if !jar_slot.jar:
				#insert jar in slot
				jar_slot.jar = iih.item
				GlobalScript.itemInHand.queue_free()
				GlobalScript.itemInHand = null
			#Non-locked slot with pot case
			elif !jar_slot.locked:
				#First harvest the plant if any
				if jar_slot.plant:
					if jar_slot.harvestable:
						GlobalInventory.insert(jar_slot.plant)
						jar_slot.harvestable = false
					GlobalInventory.insert(jar_slot.plant)
					jar_slot.plant = null
					if jar_slot.timer:
						jar_slot.timer.queue_free()
				var temp_item: Item = jar_slot.jar
				jar_slot.jar = iih.item
				GlobalScript.itemInHand.item = temp_item
				GlobalScript.itemInHand.set_texture(temp_item.texture)
					
	updateGUI()
	
func timer(jar_slot: JarSlot):
	jar_slot.timer = Timer.new()
	add_child(jar_slot.timer)
	jar_slot.timer.start(jar_slot.plant.nb_cycle)
	jar_slot.timer.connect("timeout", func() -> void:
					if jar_slot.plant: 
						jar_slot.harvestable = true
						sound_signals[jar_slot.jar.type_plant - 1].emit()
						updateGUI()
						jar_slot.timer.queue_free()
						jar_slot.timer = null)

func updateGUI():
	for slot in jar_slots:
		slot.update_gui()

#For non-locked pots: If pot + plant, remove plant. If only pot, remove pot.
func handleRightClick(slot: JarSlot) -> void:
	if slot.locked: return
	var inventory: Inventory = GlobalInventory
	#If plant, harvest plant
	if slot.plant:
		if slot.harvestable:
			inventory.insert(slot.plant)
			slot.harvestable = false
		inventory.insert(slot.plant)
		slot.plant = null
	#Else if pot, remove pot
	elif slot.jar:
		inventory.insert(slot.jar)
		slot.jar = null
	#Cancel timer
	if slot.timer:
		slot.timer.queue_free()
		slot.timer = null
	updateGUI()
