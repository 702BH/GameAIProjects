class_name RavenNodeItemHealth
extends "res://ProgrammingGameAIByExample/Raven/NodeItem.gd"


func _init() -> void:
	super._init(ItemType.HEALTH)
	item_sub_type = ItemSubType.HEALTH
