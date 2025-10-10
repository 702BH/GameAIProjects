class_name RavenNodeItemWeapon
extends "res://ProgrammingGameAIByExample/Raven/NodeItem.gd"


enum WeaponSubtype {SHOTGUN, ROCKET_LAUNCHER, BLASTER, RAIL_GUN}


static var enum_map = {
	WeaponSubtype.SHOTGUN : "Shotgun",
	WeaponSubtype.ROCKET_LAUNCHER : "Rocket Launcher",
	WeaponSubtype.BLASTER : "Blaster",
	WeaponSubtype.RAIL_GUN : "Rail Gun"
}


static var enum_map_weapon = {
	WeaponSubtype.SHOTGUN : RavenWeapon.WeaponType.SHOTGUN,
	WeaponSubtype.ROCKET_LAUNCHER : RavenWeapon.WeaponType.ROCKET_LAUNCHER,
	WeaponSubtype.BLASTER : RavenWeapon.WeaponType.BLASTER,
	WeaponSubtype.RAIL_GUN : RavenWeapon.WeaponType.RAIL_GUN
}


func _init(_weapon_type: ItemSubType) -> void:
	super._init(ItemType.WEAPON)
	item_sub_type = _weapon_type
