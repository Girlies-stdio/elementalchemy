"""
The  recipes_loader  script reads a JSON file with recipes.
The JSON file is a list of dictionaries, where each dictionary represents a recipe.
Each recipe has a category, a name and a list of ingredients.

The script reads the JSON file and creates a dictionary with the recipes.
The  get_recipe  function receives a list of ingredients and returns the recipe that matches the ingredients.
"""
extends Node

var recipes: Dictionary = {}

const FILE_PATH = "res://data/recipes/recipes.json"

func _ready():
	recipes = load_recipes(FILE_PATH)


func load_recipes(file_path : String):
	if FileAccess.file_exists(file_path) == false:
		print("Recipes file not found")
		return

	var json_file = FileAccess.open(file_path, FileAccess.READ)

	var parsed_dict = JSON.parse_string(json_file.get_as_text())
	if parsed_dict is Dictionary:
		return parsed_dict
	else:
		print("Error parsing recipe JSON file")
		return {}	

"""
The  get_recipe  function receives a list of ingredients and returns the recipe that matches the ingredients.
The ingredients list is sorted before searching for the recipe, so the order of the ingredients does not matter.

If the recipe is not found(i.e the given set of ingredients is not valid), the function returns "nothing".
"""
func get_recipe(ingredients):
	ingredients.sort()
	for recipe in recipes.values():
		if recipe["ingredients"] == ingredients:
			return recipe["name"]
	return "nothing"
