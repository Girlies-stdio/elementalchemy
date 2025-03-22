# CSV to JSON converter

import csv
import json
import sys

def csv_to_json(csv_file, json_file):

	# Open the CSV
	# Format : category, name, ingredient1, ingredient2, ingredient3
	with open(csv_file, 'r') as f:
		reader = csv.DictReader(f)
		# Create a dictionary
		recipes = {}
		# Loop through the CSV
		for row in reader:
			# Create a dictionary for the recipe
			recipe = {}
			# Add the category
			recipe['category'] = row['category']
			# Add the name
			recipe['name'] = row['name']
			# Add the ingredients
			ingredients = sorted([row['ingredient1'], row['ingredient2'], row['ingredient3']])
			recipe['ingredients'] = ingredients			
			# Add the recipe to the dictionary, using the ingredients as key
			recipes[recipe['name']] = recipe

			

	# Write the JSON
	with open(json_file, 'w') as f:
		json.dump(recipes, f, indent=4)
		

if __name__ == '__main__':
	if len(sys.argv) != 3:
		#print('Usage: csv_to_json.py <csv file> <json file>')
		default_csv = 'data/recipes/recipes.csv'
		default_json = 'data/recipes/recipes.json'
		print(f'Using default values: {default_csv} and {default_json}')
		csv_to_json(default_csv, default_json)
	else:
		csv_to_json(sys.argv[1], sys.argv[2])

