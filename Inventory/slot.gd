extends AspectRatioContainer
class_name Slot

@onready var button: TextureButton = $SlotButton
@onready var margin: MarginContainer = $SlotButton/Margin
@onready var inventory : Inventory = Global.get_node("Inventory")
var itemStackGui: ItemStackGUI

func _ready():
	var margin_value = 20
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)

func insert(isg: ItemStackGUI):
	itemStackGui = isg
	margin.add_child(itemStackGui)

func takeItem() -> ItemGUI:
	if inventory.remove(itemStackGui.item):
		var new_itemGUI = await GlobalScript.insertInHand(itemStackGui.item)
		itemStackGui.update()
		return new_itemGUI
	return null
	
func _process(delta):
	if itemStackGui:
		if itemStackGui.amount != 0:
			shade(false)
		else:
			shade(true)
			
func shade(dark: bool) -> void:
	if !dark:
		$SlotButton.material = null
		return
	var shader = Shader.new()
	var shader_material = ShaderMaterial.new()
	var shader_code = """
	shader_type canvas_item;

	uniform float darkness : hint_range(0.0, 1.0) = 0.5;

	void fragment() {
		vec4 c = texture(TEXTURE, UV);
		// On réduit la composante RGB en la multipliant
		// Exemple : "1.0 - darkness" => 0.5 => 50% plus sombre
		c.rgb *= (1.0 - darkness);
		COLOR = c;
	}
"""
	var mat = ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("darkness", 1.0)

	$SlotButton.material = mat
