extends Node

var ALL_ITEMS : Array[Item]
var itemInHand: ItemStackGUI

func _ready():
	var test = preload("res://Inventory/test.tres")
	ALL_ITEMS.append(test)
