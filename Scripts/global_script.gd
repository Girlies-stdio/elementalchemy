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
	print(recipes)
	for recipe in recipes.values():
		print("res://Inventory/Plants/"+ recipe["name"]+".tres")
		var plant = load("res://Inventory/Items/Plants/"+ recipe["name"]+".tres")
		ALL_ITEMS.append(plant)
