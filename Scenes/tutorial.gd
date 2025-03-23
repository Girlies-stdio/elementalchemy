extends Control

@onready var intro_panel = $Tuto1
@onready var garden_panel = $Tuto2
@onready var inventory_panel = $Tuto3
@onready var lab_panel = $Tuto4
@onready var end_panel = $Tuto5

@onready var intro_panel_button = $Tuto1/Panel/MarginContainer/Button
@onready var garden_panel_button = $Tuto2/MarginContainer/Panel/MarginContainer/Button
@onready var inventory_panel_button = $Tuto3/MarginContainer/Panel/MarginContainer/Button
@onready var lab_panel_button = $Tuto4/MarginContainer/Panel/MarginContainer/Button
@onready var end_panel_button = $Tuto5/Panel/MarginContainer/Button

var current_panel = 0

func _ready() -> void:
	intro_panel.show()
	garden_panel.hide()
	inventory_panel.hide()
	lab_panel.hide()
	end_panel.hide()
	
	intro_panel_button.pressed.connect(_intro_next)
	garden_panel_button.pressed.connect(_garden_next)
	inventory_panel_button.pressed.connect(_inventory_next)
	lab_panel_button.pressed.connect(_lab_next)
	end_panel_button.pressed.connect(_end_next)

func _intro_next():
	intro_panel.hide()
	garden_panel.show()

func _garden_next():
	garden_panel.hide()
	inventory_panel.show()

func _inventory_next():
	inventory_panel.hide()
	lab_panel.show()
	
func _lab_next():
	lab_panel.hide()
	end_panel.show()
	
func _end_next():
	end_panel.hide()
	self.hide()
