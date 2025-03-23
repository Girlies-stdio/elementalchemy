extends Control

@onready var panels : Array[PopupBox] = [$Tuto1, $Tuto2, $Tuto3, $Tuto4, $Tuto5]
@onready var current_panel_index = 0  # Tracks the current panel

func _ready() -> void:
	for i in range(panels.size()):
		panels[i].hide()
	panels[current_panel_index].show()

	for i in range(panels.size()):
		panels[i].primary_button_pressed.connect(_on_panel_next)
		panels[i].secondary_button_pressed.connect(_on_skip)

func _on_panel_next():
	panels[current_panel_index].hide()
	current_panel_index += 1
	
	if current_panel_index < panels.size():
		panels[current_panel_index].show()
	else:
		self.hide()

func _on_skip():
	current_panel_index = 0
	self.hide()
