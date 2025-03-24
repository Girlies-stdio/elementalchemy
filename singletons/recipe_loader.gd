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
func get_recipe(ingredients) -> String:
	var one_away: bool = false
	ingredients.sort()
	for recipe in recipes.values():
		if recipe["ingredients"] == ingredients:
			return recipe["name"]
		else : 
			if GlobalInventory.get_item(recipe["name"]).unlocked:
				continue # Ignore recipes already unlocked when checking for one_away
			one_away = one_away or checkOneAway(recipe["ingredients"], ingredients.duplicate()) 
			# short-circuit eval : stops checking if one away is alkready true
	return "one away" if one_away else "nothing"
	
func checkOneAway(recipe, ingredients) -> bool:
	var count: int = 0
	
	for ingredient in recipe:
		if ingredient == "X": 
			return false
		if !GlobalInventory.get_item(ingredient).unlocked:
			return false
		if ingredient in ingredients:
			count +=1
			ingredients.erase(ingredient)
	return count == 2
