extends TextureButton

var inv_slot : InventorySlot
@onready var parent = get_parent()
@onready var isg : ItemStackGUI = parent.itemStackGui
@onready var show_tooltip = false

func _ready():
	if !parent.is_node_ready():
		await parent.ready
		
	Global.get_node("Inventory").connect("updated", func() -> void :refresh_inv_slot())
		


func _make_custom_tooltip(for_text):
	if show_tooltip:
		var text = format_tooltip(RecipesLoader.recipes[isg.item.name])
		var recipe = RecipesLoader.recipes[isg.item.name]
		var ingredients = recipe["ingredients"]
		if text == null:
			return ""
		
		var tooltip = preload("res://Scenes/recipe_tip.tscn").instantiate()
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer2/name").text = recipe["name"]
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer2/name_text").texture = GlobalScript.findItem(recipe["name"]).texture
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer/ing1").text = ingredients[0]
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer2/ing2").text = ingredients[1]
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer3/ing3").text = ingredients[2]
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer/1").texture = GlobalScript.findItem(ingredients[0]).texture
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer2/2").texture = GlobalScript.findItem(ingredients[1]).texture
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer3/3").texture = GlobalScript.findItem(ingredients[2]).texture
		
		#tooltip.visible = true
		return tooltip
		#var label = Label.new()
		#label.text = text
		#return label
	else:
		return ""

func set_isg(new_isg : ItemStackGUI):
	isg = new_isg
	
	if isg.item == null:
		show_tooltip = false
		return
	if isg.item.name.begins_with("pot_tier"):
		show_tooltip = false
		return

		
	inv_slot = Global.get_node("Inventory").slots[isg.item]
	#show_tooltip = inv_slot.unlocked
	show_tooltip = inv_slot.unlocked

func refresh_inv_slot():
	if isg != null:
		set_isg(isg)
		
func format_tooltip(recipe: Dictionary):
	var ingredients = recipe["ingredients"]
	var format_string = "%s : %s + %s + %s"
	if ingredients[0] == "X":
		return null
	var formated = format_string % [recipe["name"], ingredients[0], ingredients[1], ingredients[2]]
	return formated
