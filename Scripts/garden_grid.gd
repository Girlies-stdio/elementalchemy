extends GridContainer

const Jar = preload("res://Scripts/jar.gd")

const GARDEN_COLUMNS = 10
const GARDEN_ROWS = 2

func _ready() -> void:
	for i in range(0, GARDEN_ROWS):
		for j in range(0, GARDEN_COLUMNS):
			var jar = Jar.new()
			add_child(jar)
