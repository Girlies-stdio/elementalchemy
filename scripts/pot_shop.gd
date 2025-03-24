extends NinePatchRect

#QUESTION: Pourquoi c'est des boutons les images des pots ? ça pourrait pas juste être des sprites ? 
@onready var button1 : Button = $MarginContainer/HBoxContainer/Type1/Button
@onready var button2 : Button = $MarginContainer/HBoxContainer/Type2/Button
@onready var button3 : Button = $MarginContainer/HBoxContainer/Type3/Button
@onready var button4 : Button = $MarginContainer/HBoxContainer/Type4/Button
@onready var buttons: Array[Button] = [button1, button2, button3, button4]

signal buying

var inventory : Inventory

var pot_costs: Dictionary[int, Array] = {1: ["Clay", "Fire", "Earth"], 2: ["Stone", "Glass", "Coal"], 3: ["Obsidian", "Diamond", "Quartz"], 4: ["Singularity", "Dark Matter", "Time"]}

@onready var margin = $MarginContainer

func _ready() -> void:
	inventory = GlobalInventory
	if !inventory.is_node_ready():
		await inventory.ready
	inventory.connect("updated", func() -> void: checkEnough())
	checkEnough()
	
	var margin_value = 40
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)
	
	for i in range(buttons.size()):
		buttons[i].connect("pressed", func() -> void: buy(i+1))
	
func checkEnough() -> void:
	for i in range(buttons.size()):
		if inventory.enough(pot_costs[i+1]):
			buttons[i].disabled = false
		else: 
			buttons[i].disabled = true

func buy(type: int):
	buying.emit()
	inventory.buy(type, pot_costs[type])
