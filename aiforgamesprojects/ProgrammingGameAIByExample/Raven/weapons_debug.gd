extends "res://ProgrammingGameAIByExample/Raven/tab_debug_node.gd"


@onready var selected_weapon_text := $DebugContainer/Weapon/weapon

var process_functions = {
	WeaponData.Steps.WEAPON_SELECTION : Callable(debug_weapon)
}

func handle_debug_event(data: DebugData) -> void:
	var function = process_functions.get(data.step)
	function.call(data)


func debug_weapon(data: DebugData) -> void:
	for message in data.messages:
		selected_weapon_text.text = message



func clear_debug() -> void:
	selected_weapon_text.text = ""
