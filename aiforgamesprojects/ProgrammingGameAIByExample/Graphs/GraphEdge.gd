class_name GraphEdge
extends Node


var from : int
var to : int
var cost: float

func _init(context_from:int, context_to:int, context_cost:float) -> void:
	from = context_from
	to = context_to
	cost = context_cost


func edge_text() -> String:
	return "Source: %d - Target: %d" %[from, to]
