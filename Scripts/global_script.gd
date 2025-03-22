extends Node

var ALL_ITEMS : Array[Item]
var itemInHand: ItemStackGUI

func _ready():
	var test = preload("res://Inventory/test.tres")
	for i in range(12):
		ALL_ITEMS.append(test)
