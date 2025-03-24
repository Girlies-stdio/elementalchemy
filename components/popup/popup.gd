extends MarginContainer
class_name PopupBox

signal primary_button_pressed
signal secondary_button_pressed

@onready var textbox : RichTextLabel = $Panel/Margin/VBox/Text
@onready var primary_button : Button = $Panel/Margin/VBox/HBox/PrimaryButton
@onready var secondary_button : Button = $Panel/Margin/VBox/HBox/SecondaryButton
@onready var panel : PanelContainer = $Panel

@export var panel_horizontal: SizeFlags = SizeFlags.SIZE_SHRINK_CENTER :
	set(flag):
		panel_horizontal = flag
		if is_node_ready():
			panel.size_flags_horizontal = panel_horizontal
			
@export var panel_vertical: SizeFlags = SizeFlags.SIZE_SHRINK_CENTER :
	set(flag):
		panel_vertical = flag
		if is_node_ready():
			panel.size_flags_vertical = panel_vertical

@export_multiline var text: String = "Popup text" :
	set(new_text):
		text = new_text
		if is_node_ready():
			textbox.text = new_text
		
@export var primary_button_label : String = "Next" :
	set(label):
		primary_button_label = label
		if is_node_ready():
			primary_button.text = label

@export var secondary_button_label : String = "Skip" :
	set(label):
		secondary_button_label = label
		if is_node_ready():
			secondary_button.text = label

@export var hide_secondary_button : bool = false :
	set(hide):
		hide_secondary_button = hide
		if (hide):
			secondary_button.hide()
		else:
			secondary_button.show()

func _ready():
	textbox.text = text
	primary_button.text = primary_button_label
	secondary_button.text = secondary_button_label
	
	panel.size_flags_horizontal = panel_horizontal
	panel.size_flags_vertical = panel_vertical
	
	primary_button.pressed.connect(_on_primary_button_pressed)
	secondary_button.pressed.connect(_on_secondary_button_pressed)

	

func _on_primary_button_pressed():
	emit_signal("primary_button_pressed")
	
func _on_secondary_button_pressed():
	emit_signal("secondary_button_pressed")
	
