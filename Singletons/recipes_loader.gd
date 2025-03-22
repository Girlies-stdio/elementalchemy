"""
The  recipes_loader  script reads a JSON file with recipes.
The JSON file is a list of dictionaries, where each dictionary represents a recipe.
Each recipe has a category, a name and a list of ingredients.

The script reads the JSON file and creates a dictionary with the recipes.
The dictionary has the sorted list of ingredients as keys and the recipes as values.

"""
extends Node

var recipes = {}

const FILE_PATH = "res://data/recipes.csv"

func _ready():
	recipes = load_recipes(FILE_PATH)


func load_recipes(file_path : String):
	if FileAccess.file_exists(file_path) == false:
		print("Recipes file not found")
		return

	var json_file = FileAccess.open(file_path, FileAccess.READ)

	var parsed_dict = JSON.parse_string(json_file.get_as_text())
	if parsed_dict is Dictionary:
		for recipe in parsed_dict:
			var ingredients = recipe["ingredients"]
			ingredients.sort()
			recipes[ingredients] = recipe
		return recipes
	else:
		print("Error parsing JSON file")
		return {}	

func get_recipe(ingredients):
	ingredients.sort()
	return recipes[ingredients]