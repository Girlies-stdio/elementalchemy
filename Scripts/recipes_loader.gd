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
	load_recipes()


func load_recipes():
	var json = JSON.new()

	var json_file = load(FILE_PATH)
	var parsed_dict = json.parse(json_file.get_data())
	if json_file == null:
		print("Error loading file")
		return

	for recipe in parsed_dict:
		recipe["ingredients"].sort()
		recipes[recipe["ingredients"]] = recipe			

func get_recipe(ingredients):
	ingredients.sort()
	return recipes[ingredients]
