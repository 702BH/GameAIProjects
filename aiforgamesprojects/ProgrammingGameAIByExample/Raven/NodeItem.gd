class_name RavenNodeItem
extends RefCounted

enum ItemType {WEAPON, HEALTH}
enum ItemSubType {SHOTGUN, ROCKET_LAUNCHER, BLASTER, RAIL_GUN, HEALTH}

var item_type : ItemType
var properties := {}
var item_sub_type : ItemSubType

func _init(_item_type: ItemType) -> void:
	item_type = _item_type
