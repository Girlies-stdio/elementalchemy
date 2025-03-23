extends NinePatchRect

#QUESTION: Pourquoi c'est des boutons les images des pots ? ça pourrait pas juste être des sprites ? 
@onready var button1 : Button = $MarginContainer/HBoxContainer/Type1/Button
@onready var button2 : Button = $MarginContainer/HBoxContainer/Type2/Button
@onready var button3 : Button = $MarginContainer/HBoxContainer/Type3/Button
@onready var button4 : Button = $MarginContainer/HBoxContainer/Type4/Button
var inventory : Inventory

@onready var margin = $MarginContainer

func _ready() -> void:
	inventory = Global.get_node("Inventory")
	inventory.connect("updated", func() -> void: checkEnough())
	checkEnough()
	
	var margin_value = 40
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)
	
func checkEnough() -> void:
	if inventory.enough(["Clay", "Fire", "Earth"]):
		button1.disabled = false
	else:
		button1.disabled = true
		
	if inventory.enough(["Stone", "Glass", "Coal", "Gold", "Iron"]):
		button2.disabled = false
	else:
		button2.disabled = true
		
	if inventory.enough(["Obsidian", "Diamond", "Quartz"]):
		button3.disabled = false
	else:
		button3.disabled = true
		
	if inventory.enough(["Singularity", "Dark Matter", "Time"]):
		button4.disabled = false
	else:
		button4.disabled = true

func buy(type: int):
	$"../../../../../craft".play()
	match type:
		1: #Clay, Fire, Earth
			inventory.buy(1, ["Clay", "Fire", "Earth"])
		2: #Rock, glass, Coal, Gold, Iron
			inventory.buy(2, ["Stone", "Glass", "Coal", "Gold", "Iron"])
		3: #Obsidian, Diamond, Quartz
			inventory.buy(3, ["Obsidian", "Diamond", "Quartz"])
		4: #Singularity, Dark Matter, Time
			inventory.buy(4, ["Singularity", "Dark Matter", "Time"])


func _on_button1_pressed():
	buy(1)

func _on_button2_pressed():
	buy(2)

func _on_button3_pressed():
	buy(3)

func _on_button4_pressed():
	buy(4)
