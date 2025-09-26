class_name RavenNodeItem
extends RefCounted

enum ItemType {WEAPON, HEALTH}


var item_type : ItemType
var properties := {}

func _init(_item_type: ItemType) -> void:
	item_type = _item_type
