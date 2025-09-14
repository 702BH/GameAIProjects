class_name RavenNodeItem
extends Node

enum ItemType {WEAPON, HEALTH}


var item_type : ItemType
var properties := {}

func _init(_item_type: ItemType) -> void:
	item_type = _item_type
