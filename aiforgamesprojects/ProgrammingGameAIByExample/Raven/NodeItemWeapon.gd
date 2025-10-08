class_name RavenNodeItemWeapon
extends "res://ProgrammingGameAIByExample/Raven/NodeItem.gd"


enum WeaponSubtype {SHOTGUN, ROCKET_LAUNCHER, BLASTER, RAIL_GUN}

static var enum_map = {
	WeaponSubtype.SHOTGUN : "Shotgun",
	WeaponSubtype.ROCKET_LAUNCHER : "Rocket Launcher",
	WeaponSubtype.BLASTER : "Blaster",
	WeaponSubtype.RAIL_GUN : "Rail Gun"
}

func _init(_weapon_type: ItemSubType) -> void:
	super._init(ItemType.WEAPON)
	item_sub_type = _weapon_type
