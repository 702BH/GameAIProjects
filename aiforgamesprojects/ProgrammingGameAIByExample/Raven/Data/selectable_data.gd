class_name SelectableData
extends RefCounted


enum WeaponSubtype {SHOTGUN, ROCKET_LAUNCHER, BLASTER, RAIL_GUN}
enum PlaceableType {Health, Weapon, Spawn}

static var enum_map = {
	WeaponSubtype.SHOTGUN : "Shotgun",
	WeaponSubtype.ROCKET_LAUNCHER : "Rocket Launcher",
	WeaponSubtype.BLASTER : "Blaster",
	WeaponSubtype.RAIL_GUN : "Rail Gun"
}


var node: RavenNode
var placeable_type : PlaceableType
var weapon_sub_type : WeaponSubtype

static func build() -> SelectableData:
	return SelectableData.new()

func set_node(_node: RavenNode) -> SelectableData:
	node = _node
	return self

func set_placeable_type(_placeable: PlaceableType) -> SelectableData:
	placeable_type = _placeable
	return self

func set_weapon_sub_type(_t : WeaponSubtype) -> SelectableData:
	weapon_sub_type = _t
	return self
