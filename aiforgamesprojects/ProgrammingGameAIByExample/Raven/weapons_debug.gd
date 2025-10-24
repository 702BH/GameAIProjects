extends "res://ProgrammingGameAIByExample/Raven/tab_debug_node.gd"


@onready var selected_weapon_text := $DebugContainer/Weapon/weapon
@onready var weapon_inventory_scene := preload("res://ProgrammingGameAIByExample/Raven/UI/weapon_inventory.tscn")
@onready var items := $DebugContainer/Inventory/Items

# key = raven weapon
# value = instantiate inventory item
var weapon_dict : Dictionary = {}

var process_functions = {
	WeaponData.Steps.WEAPON_SELECTION : Callable(debug_weapon),
	WeaponData.Steps.WEAPON_ADDED : Callable(add_weapon)
}

func handle_debug_event(data: DebugData) -> void:
	var function = process_functions.get(data.step)
	function.call(data)


func debug_weapon(data: DebugData) -> void:
	for message in data.messages:
		selected_weapon_text.text = message

func add_weapon(data: DebugData) -> void:
	# Expecting to recieve an array of arrays:
	# [Weapon, Ammo]
	for message: Array in data.messages:
		# if we already have the weapon, update the ammo in the inventory
		# if we dont have, then instantiate new inventory scene and update
		if !weapon_dict.has(message[0]):
			# if dont have, instantiate new inventory 
			var inventory : WeaponInventory = weapon_inventory_scene.instantiate()
			weapon_dict[message[0]] = inventory
			items.add_child(inventory)
		var weapon_inventory : WeaponInventory = weapon_dict[message[0]]
		weapon_inventory.update_weapon_info(message[0].name, message[1])




func clear_debug() -> void:
	selected_weapon_text.text = ""
