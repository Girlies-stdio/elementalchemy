extends TextureRect

class_name ItemStackGUI

@onready var amountLabel: Label = $Label
var item: Item
var inventory: Inventory
var amount: int

func _ready():
	inventory = Global.get_node("Inventory")
	if !inventory.is_node_ready():
		await inventory.ready

func _process(_delta):
	amountLabel.visible = true if amount > 1 else false

#TODO: Potentiellement griser ici le sprite si on en a 0, et lock si on n'a pas débloqué
func update():
	var slot = inventory.slots[item]
	amount = slot.amount
	amountLabel.text = str(amount)
	if slot.unlocked:
		if amount == 0:
			shade("gray")
		else:
			shade("classic")
	else:
		shade("black")

func shade(mode: String) -> void:
		var shader = Shader.new()
		var shader_material = ShaderMaterial.new()
		var shader_code
		match mode:
			"gray":
				shader_code = """
					shader_type canvas_item;

					void fragment() {
						vec4 c = texture(TEXTURE, UV);
						float gray = (c.r + c.g + c.b) / 3.0;
						COLOR = vec4(gray, gray, gray, c.a);
					}
				"""
			"black":
				shader_code = """
					shader_type canvas_item;

					void fragment() {
						vec4 c = texture(TEXTURE, UV);
						// Conserver l'alpha, forcer la couleur à noir
						COLOR = vec4(0.0, 0.0, 0.0, c.a);
					}
				"""
			_:
				material = null
				return
		shader.code = shader_code
		shader_material.shader = shader
		material = shader_material
