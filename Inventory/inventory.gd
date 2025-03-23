extends Node2D
class_name Inventory

signal updated

var slots: Dictionary[Item, InventorySlot] = {}

#Schéma global de fonctionnement : On a N slots, chaque slot pouvant contenir un objet et un montant de cet objet. Quand on ajoute un objet à l'inventaire,
#Soit on le met où on veut, soit il s'ajoute automatiquement au milieu. Donc faut pouvoir insert At. Dans le GUI on a un objet en main.

#Add all possible items to the inventory
func _ready():
	await GlobalScript.ready
	for i in range(GlobalScript.ALL_ITEMS.size()):
		var slot = InventorySlot.new()
		slot.amount = 0
		slot.unlocked = false
		slots[GlobalScript.ALL_ITEMS[i]] = slot
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
	
func enough(elements: Array[String]) -> bool:
	var items = elements.map(func(s) -> Item: return GlobalScript.findItem(s))
	#This nullCheck is only added because we don't have all the elements in the game right now
	if null in items:
		return false
	for item in items:
		if slots[item].amount < 1:
			return false
	return true
	
func buy(potType: int, elements: Array[String]) -> void:
	if enough(elements):
		var items = elements.map(func(s) -> Item: return GlobalScript.findItem(s))
		for item in items:
			remove(item)
		
		var pot = GlobalScript.ALL_ITEMS[potType - 1]
		insert(pot)
func devCheat() -> void:
	for key in slots.keys():
		insert(key)

func handle_recipe_discovery(item : Item):
	print("yaaay, you unlocked "+ item.name)
