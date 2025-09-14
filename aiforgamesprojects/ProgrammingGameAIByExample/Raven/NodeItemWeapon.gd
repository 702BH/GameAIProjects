class_name RavenNodeItemWeapon
extends "res://ProgrammingGameAIByExample/Raven/NodeItem.gd"


enum WeaponSubtype {SHOTGUN, ROCKET_LAUNCHER}

var weapon_type

func _init(_weapon_type: WeaponSubtype) -> void:
	super._init(ItemType.WEAPON)
	weapon_type = _weapon_type
