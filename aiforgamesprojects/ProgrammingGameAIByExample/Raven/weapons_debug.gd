extends "res://ProgrammingGameAIByExample/Raven/tab_debug_node.gd"


@onready var selected_weapon_text := $DebugContainer/Weapon/weapon

var weapon_dict : Dictionary = {}

var process_functions = {
	WeaponData.Steps.WEAPON_SELECTION : Callable(debug_weapon)
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
		pass
	


func clear_debug() -> void:
	selected_weapon_text.text = ""
