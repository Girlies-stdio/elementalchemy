extends NinePatchRect

#QUESTION: Pourquoi c'est des boutons les images des pots ? ça pourrait pas juste être des sprites ? 
@onready var button1 : Button = $HBoxContainer/Type1/Button
@onready var button2 : Button = $HBoxContainer/Type2/Button
@onready var button3 : Button = $HBoxContainer/Type3/Button
@onready var button4 : Button = $HBoxContainer/Type4/Button
@onready var inventory : Inventory = Global.get_node("Inventory")

#func _ready() -> void:
#	Global.get_node("Inventory").connect("updated", func() -> void: print("updated"))

func buy(type: int):
	print("buying pot ", str(type))
	match type:
		1: #Clay, Fire, Earth
			if inventory.buy(1, ["Clay", "Fire", "Earth"]):
				#Etre content
				pass
			else:
				#Che7
				pass
		2: #Rock, glass, Coal, Gold, Iron
			if inventory.buy(2, ["Rock", "Glass", "Coal", "Gold", "Iron"]):
				#Etre content
				pass
			else:
				#Che7
				pass
		3: #Obsidian, Diamond, Quartz
			if inventory.buy(3, ["Obsidian", "Diamond", "Quartz"]):
				#Etre content
				pass
			else:
				#Che7
				pass
		4: #Singularity, Dark Matter, Time
			if inventory.buy(4, ["Singularity", "Dark Matter", "Time"]):
				#Etre content
				pass
			else:
				#Che7
				pass

func _on_button1_pressed():
	buy(1)

func _on_button2_pressed():
	buy(2)

func _on_button3_pressed():
	buy(3)

func _on_button4_pressed():
	buy(4)
