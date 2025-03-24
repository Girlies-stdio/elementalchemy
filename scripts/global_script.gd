extends Node

var ALL_ITEMS : Array[Item] = []
var name_to_item: Dictionary[String, Item] = {}
var itemInHand: ItemGUI

var mouseItem: MouseItem

func _ready():
	var tier1 = preload("res://inventory/items/pots/pot_tier1.tres")
	var tier2 = preload("res://inventory/items/pots/pot_tier2.tres")
	var tier3 = preload("res://inventory/items/pots/pot_tier3.tres")
	var tier4 = preload("res://inventory/items/pots/pot_tier4.tres")
	ALL_ITEMS.append(tier1)
	name_to_item[tier1.name] = tier1
	ALL_ITEMS.append(tier2)
	name_to_item[tier2.name] = tier2
	ALL_ITEMS.append(tier3)
	name_to_item[tier3.name] = tier3
	ALL_ITEMS.append(tier4)
	name_to_item[tier4.name] = tier4
	if !RecipesLoader.is_node_ready():
		await RecipesLoader.ready
	var recipes = RecipesLoader.recipes
	for recipe in recipes.values():
		var plant = load("res://inventory/items/plants/"+ recipe["name"]+".tres")
		ALL_ITEMS.append(plant)
		name_to_item[plant.name] = plant
		
func insertInHand(item: Item) -> ItemGUI:
	if itemInHand: return null
	var new_itemGUI = preload("res://scenes/item_gui.tscn").instantiate()
	mouseItem.add_child(new_itemGUI)
	if !new_itemGUI.is_node_ready():
		await new_itemGUI.ready
	new_itemGUI.item = item
	new_itemGUI.set_texture(item.texture)
	
	itemInHand = new_itemGUI
	
	return itemInHand
	
func findItem(label: String) -> Item:
	return name_to_item.get(label)
	
func createMouseItem():
	mouseItem = preload("res://components/mouse_item/mouse_item.tscn").instantiate()
	get_tree().current_scene.add_child(mouseItem)
	
