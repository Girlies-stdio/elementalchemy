extends NinePatchRect

@onready var input_slot_1 : ItemSlot = $Brewing/InputSlot1
@onready var input_slot_2 : ItemSlot = $Brewing/InputSlot2
@onready var input_slot_3 : ItemSlot = $Brewing/InputSlot3
@onready var output_slot : ItemSlot = $Brewing/OutputSlot
@onready var combine_button = $MarginContainer/CombineButton
@onready var notification_popup = $NotificationPopUp
var slots: Array[ItemSlot]

signal sound_combine
signal sound_brew

@onready var margin = $MarginContainer

func _ready():
	# No need to connect gui_input signals, just connect the cook button
	combine_button.pressed.connect(_combine_pressed)
	slots = [input_slot_1, input_slot_2, input_slot_3, output_slot]
	
	# Initialize slots
	for slot in slots:
		slot.item = null
		slot.connect("pressed", func() -> void : handle_slot_interaction(slot))
		slot.connect("right_clicked", func() -> void : handle_right_click(slot))
	
	# Update UI
	update_slot_visuals()
	
	var margin_value = 20
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)

# Handle slot interaction (called from Slot._on_slot_pressed)
func handle_slot_interaction(slot: ItemSlot):
	if slot == output_slot:
		# Output slot can only give items
		if !GlobalScript.itemInHand and slot.item:
			GlobalInventory.insert(slot.item)
			slot.item = null
	else:
		# Input slots can give and receive items
		if !GlobalScript.itemInHand and slot.item:
			# Take item from slot
			GlobalScript.insertInHand(slot.item)
			GlobalScript.itemInHand.global_position = get_global_mouse_position()
			slot.item = null
		elif GlobalScript.itemInHand  and GlobalScript.itemInHand.item is Plant and !slot.item:
			# Place item in slot
			slot.item = GlobalScript.itemInHand.item
			GlobalScript.itemInHand.queue_free()
			GlobalScript.itemInHand = null
			sound_brew.emit()
		elif GlobalScript.itemInHand  and GlobalScript.itemInHand.item is Plant and slot.item:
			#Swap items
			var temp_item : Item = slot.item
			slot.item = GlobalScript.itemInHand.item
			#Note: Here we edit item in hand, but we could also free it and insert a new one
			GlobalScript.itemInHand.item = temp_item
			GlobalScript.itemInHand.set_texture(temp_item.texture)
			sound_brew.emit()

	update_slot_visuals()
	
func handle_right_click(slot: ItemSlot) -> void:
	if slot.item:
		GlobalInventory.insert(slot.item)
		slot.item = null
		update_slot_visuals()

# Handle cook button press
func _combine_pressed():
	if output_slot.item:
		# Cannot cook if output slot is occupied
		notification_popup.show_text("You need to collect the newly synthesized atom first", 1.1)
		return
	
	# Get current ingredients
	var ingredients = [input_slot_1.item, input_slot_2.item, input_slot_3.item]
	
	# Check if all slots have ingredients
	if null in ingredients:
		notification_popup.show_text("You need 3 atoms to synthesize a new one", 1.0)
		return
	ingredients = ingredients.map(func(item): return item.name)
	
	# Check if recipe exists
	var recipe_result = check_recipe(ingredients)
	if recipe_result:
		# Clear input slots
		input_slot_1.item = null
		input_slot_2.item = null
		input_slot_3.item = null
		
		# Set output slot
		output_slot.item = recipe_result
		sound_combine.emit()
		
		update_slot_visuals()

# Check if the current ingredients match a recipe
func check_recipe(ingredients) -> Item:
	var result = RecipesLoader.get_recipe(ingredients)
	if result == "nothing":
		handle_failed_recipe()
		return null
	elif result == "one away":
		print("one away")
		notification_popup.show_text("One away from a new recipe...")
		
		#TODO: UI
		return null
	else:
		return GlobalScript.findItem(result)
		

func handle_failed_recipe():
	print("failed recipe")
	# TODO : give hint

# Update visual representation of slots

func update_slot_visuals():
	for slot in slots:
		var sprite = slot.item_sprite
		if slot.item:
			sprite.texture = slot.item.texture
		else:
			sprite.texture = null
