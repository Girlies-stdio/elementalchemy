extends TextureButton

var inv_slot : InventorySlot
@onready var parent = get_parent()
@onready var isg = parent.itemStackGui
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
		var type = recipe["category"]
		
		if text == null:
			return ""
		
		#Instantiate tooltip scene
		var tooltip = preload("res://Scenes/recipe_tip.tscn").instantiate()
		
		#Show name, picture of the ingredients & pot it grows in
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer2/name").text = recipe["name"]
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer2/name_text").texture = GlobalScript.findItem(recipe["name"]).texture
		var res = load("res://Inventory/Items/Pots/pot_tier"+type+".tres")
		tooltip.get_node("Panel/VBoxContainer/HBoxContainer2/pot").texture = res.texture
		tooltip.custom_minimum_size = Vector2(300.,25.)
		
		#If ingredient unlocked (and with a recipe) show the recipee too
		if(inv_slot.unlocked && ingredients[0] != "X"):
			tooltip.custom_minimum_size = Vector2(300.,50.)
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer/ing1").text = ingredients[0]
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer2/ing2").text = ingredients[1]
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer3/ing3").text = ingredients[2]
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer/1").texture = GlobalScript.findItem(ingredients[0]).texture
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer2/2").texture = GlobalScript.findItem(ingredients[1]).texture
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/HBoxContainer3/3").texture = GlobalScript.findItem(ingredients[2]).texture
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/Label2").show()
			tooltip.get_node("Panel/VBoxContainer/HBoxContainer/Label").show()
		return tooltip
	
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
	show_tooltip = inv_slot

func refresh_inv_slot():
	if isg != null:
		set_isg(isg)
		
func format_tooltip(recipe: Dictionary):
	var ingredients = recipe["ingredients"]
	var format_string = "%s : %s + %s + %s"
	var formated = format_string % [recipe["name"], ingredients[0], ingredients[1], ingredients[2]]
	return formated
