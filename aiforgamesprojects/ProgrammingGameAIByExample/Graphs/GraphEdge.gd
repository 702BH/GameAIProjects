class_name GraphEdge
extends Node


var from : GraphVertex
var to : GraphVertex
var cost: float

func _init(context_from:GraphVertex, context_to:GraphVertex, context_cost:float) -> void:
	from = context_from
	to = context_to
	cost = context_cost
