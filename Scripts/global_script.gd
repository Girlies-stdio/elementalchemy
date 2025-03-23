extends Node

var ALL_ITEMS : Array[Item]
var itemInHand: ItemGUI

func _ready():
	var tier1 = preload("res://Inventory/Items/Pots/pot_tier1.tres")
	var tier2 = preload("res://Inventory/Items/Pots/pot_tier2.tres")
	var tier3 = preload("res://Inventory/Items/Pots/pot_tier3.tres")
	var tier4 = preload("res://Inventory/Items/Pots/pot_tier4.tres")
	ALL_ITEMS.append(tier1)
	ALL_ITEMS.append(tier2)
	ALL_ITEMS.append(tier3)
	ALL_ITEMS.append(tier4)
	if !RecipesLoader.is_node_ready():
		await RecipesLoader.ready
	var recipes = RecipesLoader.recipes
	for recipe in recipes.values():
		var plant = load("res://Inventory/Items/Plants/"+ recipe["name"]+".tres")
		ALL_ITEMS.append(plant)
		
func insertInHand(item: Item) -> ItemGUI:
	if itemInHand: return null
	var new_itemGUI = preload("res://Scenes/item_gui.tscn").instantiate()
	get_tree().current_scene.add_child(new_itemGUI)
	if !new_itemGUI.is_node_ready():
		await new_itemGUI.ready
	new_itemGUI.item = item
	new_itemGUI.itemSprite.set_texture(item.texture)
	
	itemInHand = new_itemGUI
	return itemInHand
