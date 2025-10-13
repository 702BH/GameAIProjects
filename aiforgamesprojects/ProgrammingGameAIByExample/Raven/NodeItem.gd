class_name RavenNodeItem
extends RefCounted

enum ItemType {WEAPON, HEALTH}
enum ItemSubType {SHOTGUN, ROCKET_LAUNCHER, BLASTER, RAIL_GUN, HEALTH}

var item_type : ItemType
var properties := {}
var item_sub_type : ItemSubType

var associated_trigger: Trigger

func _init(_item_type: ItemType) -> void:
	item_type = _item_type


func set_associated_trigger(trig:Trigger) -> void:
	associated_trigger = trig
