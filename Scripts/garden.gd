extends GridContainer

# A garden is a collection of jar slots.
# Each slot can contain a jar, and possibly a plant.
# There are several types of jars, each with different properties.
# Plants require a certain jar type to be placed in.
# Each plant has a growth time and can be harvested when fully grown.

const GARDEN_SLOTS = 10

var jar_slots: Array[JarSlot] = []
var sound_type: Array[AudioStreamPlayer] = []

signal putItemBack

# Initialize the garden with empty jar slots.
func _ready() -> void:
	sound_type = [$"../../../../../plant",$"../../../../../cave",$"../../../../../crystal",$"../../../../../endgame"]
	var jar1 = GlobalScript.ALL_ITEMS[0]
	for i in range(0, GARDEN_SLOTS):
		var jar_slot : JarSlot = $JarSlot if i == 0 else get_node("JarSlot" + str(i + 1))
		jar_slot.jar = null
		jar_slot.plant = null
		jar_slots.append(jar_slot)
		jar_slot.connect("pressed", func() -> void : handle_interaction(jar_slot))
		if i < 4:
			jar_slot.jar = jar1
			jar_slot.plant = GlobalScript.ALL_ITEMS[i + 4]
			timer(jar_slot)
		else:
			jar_slot.connect("right_clicked", func() -> void : handleRightClick(jar_slot))

		updateGUI()

	
func handle_interaction(jar_slot: JarSlot): 
	var iih : ItemGUI = GlobalScript.itemInHand
	
	#cases : no item in hand and plant ready to collect -> add to inventory
	# no item in hand and empty pot in slot -> put back pot in hand
	if !iih:
		if jar_slot.jar && !jar_slot.plant:
			#put jar in hand
			GlobalScript.insertInHand(jar_slot.jar)
			GlobalScript.itemInHand.global_position = get_global_mouse_position()

			jar_slot.jar = null
		elif jar_slot.jar && jar_slot.plant:
			#if grown, harvest
			if jar_slot.potSprite.texture == jar_slot.jar.texture_ready:
				GlobalScript.insertInHand(jar_slot.plant)
				GlobalScript.itemInHand.global_position = get_global_mouse_position()
				putItemBack.emit()
				timer(jar_slot)
				jar_slot.harvestable = false
	else:
		if jar_slot.jar && !jar_slot.plant && iih.item is Plant:
			if jar_slot.jar.type_plant == iih.item.type_plant:
				#insert plant in slot, then start timer
				jar_slot.plant = iih.item
				GlobalScript.itemInHand.queue_free()
				GlobalScript.itemInHand = null
				timer(jar_slot)
			else: 
				#back in inventory
				putItemBack.emit()
			
		elif !jar_slot.jar && !jar_slot.plant && iih.item is Pot:
			#insert jar in slot
			jar_slot.jar = iih.item
			GlobalScript.itemInHand.queue_free()
			GlobalScript.itemInHand = null
	updateGUI()
	
func timer(jar_slot: JarSlot):
	jar_slot.timer = Timer.new()
	add_child(jar_slot.timer)
	jar_slot.timer.start(jar_slot.plant.nb_cycle)
	jar_slot.timer.connect("timeout", func() -> void:
					if jar_slot.plant: 
						jar_slot.harvestable = true
						sound_type[jar_slot.jar.type_plant - 1].play()
						updateGUI()
						jar_slot.timer.queue_free()
						jar_slot.timer = null)

func updateGUI():
	for slot in jar_slots:
		slot.update_gui()
			
func handleRightClick(slot: JarSlot) -> void:
	var inventory: Inventory = Global.get_node("Inventory")
	if slot.plant:
		if slot.harvestable:
			inventory.insert(slot.plant)
			slot.harvestable = false
		inventory.insert(slot.plant)
		slot.plant = null
	if slot.jar:
		inventory.insert(slot.jar)
		slot.jar = null
	if slot.timer:
		slot.timer.queue_free()
		slot.timer = null
	updateGUI()
