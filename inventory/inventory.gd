extends Node2D
class_name Inventory

signal updated

var slots: Dictionary[Item, InventorySlot] = {}

#Schéma global de fonctionnement : On a N slots, chaque slot pouvant contenir un objet et un montant de cet objet. Quand on ajoute un objet à l'inventaire,
#Soit on le met où on veut, soit il s'ajoute automatiquement au milieu. Donc faut pouvoir insert At. Dans le GUI on a un objet en main.

#Add all possible items to the inventory
func _ready():
	if !GlobalScript.is_node_ready():
		await GlobalScript.ready
	for item in GlobalScript.ALL_ITEMS:
		var slot = InventorySlot.new()
		slot.amount = 0
		slot.unlocked = false
		slots[item] = slot
	#devCheat()

func insert(item: Item, n: int = 1) -> void:
	var slot = slots[item]
	slot.amount += n
	if slot.unlocked == false:
		slot.unlocked = true
		handle_recipe_discovery(item)
	updated.emit()

func remove(item: Item, n: int = 1) -> bool:
	var slot = slots[item]
	if slot.amount >= n:
		slot.amount -= n
		updated.emit()
		return true
	return false
	
func get_item(item) -> InventorySlot:
	if item is Item:
		return slots[item]
	elif item is String:
		return slots[GlobalScript.findItem(item)]
	else:
		return null

func enough(elements: Array) -> bool:
	var items = elements.map(func(s: String) -> Item: return GlobalScript.findItem(s))
	for item in items:
		if slots[item].amount < 1:
			return false
	return true
	
func buy(potType: int, elements: Array) -> void:
	if enough(elements):
		var items = elements.map(func(s: String) -> Item: return GlobalScript.findItem(s))
		for item in items:
			remove(item)
			
		var pot = GlobalScript.ALL_ITEMS[potType - 1]
		insert(pot)
func devCheat() -> void:
	for key in slots.keys():
		insert(key)

func handle_recipe_discovery(item : Item):
	print("yaaay, you unlocked "+ item.name)
