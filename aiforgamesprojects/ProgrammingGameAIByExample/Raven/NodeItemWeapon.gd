class_name RavenNodeItemWeapon
extends "res://ProgrammingGameAIByExample/Raven/NodeItem.gd"


enum WeaponSubtype {SHOTGUN, ROCKET_LAUNCHER, BLASTER, RAIL_GUN}

static var enum_map = {
	WeaponSubtype.SHOTGUN : "Shotgun",
	WeaponSubtype.ROCKET_LAUNCHER : "Rocket Launcher",
	WeaponSubtype.BLASTER : "Blaster",
	WeaponSubtype.RAIL_GUN : "Rail Gun"
}

var weapon_type

func _init(_weapon_type: WeaponSubtype) -> void:
	super._init(ItemType.WEAPON)
	weapon_type = _weapon_type
