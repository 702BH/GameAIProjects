class_name WeaponData
extends "res://ProgrammingGameAIByExample/Raven/Debug/debug_data_base.gd"

enum Steps {WEAPON_SELECTION, WEAPON_ADDED}


func add_message_inventory(ms: Array) ->DebugData:
	messages.append(ms)
	return self
