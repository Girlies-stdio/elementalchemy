extends NinePatchRect

@onready var input_slot_1 = $Brewing/InputSlot1
@onready var input_slot_2 = $Brewing/InputSlot2
@onready var input_slot_3 = $Brewing/InputSlot3
@onready var output_slot = $Brewing/OutputSlot
@onready var combine_button = $CombineButton

func _ready():
	# No need to connect gui_input signals, just connect the cook button
	combine_button.pressed.connect(_combine_pressed)
	
	# Initialize slots
	input_slot_1.item = null
	input_slot_2.item = null
	input_slot_3.item = null
	output_slot.item = null
	
	# Update UI
	update_slot_visuals()

# Handle slot interaction (called from Slot._on_slot_pressed)
func handle_slot_interaction(slot):
	if slot == output_slot:
		# Output slot can only give items
		if GlobalScript.itemInHand == null and slot.item != null:
			GlobalScript.itemInHand = slot.item
			slot.item = null
			update_slot_visuals()
	else:
		# Input slots can give and receive items
		if GlobalScript.itemInHand == null and slot.item != null:
			# Take item from slot
			GlobalScript.itemInHand == null
			slot.item = null
		elif GlobalScript.itemInHand != null and slot.item == null:
			# Place item in slot
			slot.item = GlobalScript.itemInHand
			GlobalScript.itemInHand = null
		
		update_slot_visuals()

# Handle cook button press
func _combine_pressed():
	if output_slot.item != null:
		# Cannot cook if output slot is occupied
		return
	
	# Get current ingredients
	var ingredients = [input_slot_1.item, input_slot_2.item, input_slot_3.item]
	
	# Check if all slots have ingredients
	if null in ingredients:
		return
	
	# Check if recipe exists
	var recipe_result = check_recipe(ingredients)
	if recipe_result:
		# Clear input slots
		input_slot_1.item = null
		input_slot_2.item = null
		input_slot_3.item = null
		
		# Set output slot
		output_slot.item = recipe_result
		
		update_slot_visuals()

# Check if the current ingredients match a recipe
func check_recipe(ingredients):
	return true

# Update visual representation of slots
func update_slot_visuals():
	update_slot_visual(input_slot_1)
	update_slot_visual(input_slot_2)
	update_slot_visual(input_slot_3)
	update_slot_visual(output_slot)

# Update visual representation of a single slot
func update_slot_visual(slot):
	# Clear existing visuals
	for child in slot.get_children():
		if child.is_in_group("item_visual"):
			child.queue_free()
	
	if slot.item != null:
		var item_sprite = Sprite2D.new()
		item_sprite.texture = load("res://assets/items/" + slot.item + ".png")
		item_sprite.centered = true
		item_sprite.position = Vector2(slot.size.x / 2, slot.size.y / 2)
		item_sprite.add_to_group("item_visual")
		slot.add_child(item_sprite)
