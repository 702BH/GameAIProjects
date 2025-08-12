class_name GraphVertex
extends Node


var id : int

func _init(_id:int) -> void:
	id = _id



func vertex_text() -> String:
	return "Node: %d" %id
