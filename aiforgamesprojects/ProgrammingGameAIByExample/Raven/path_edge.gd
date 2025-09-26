class_name PathEdge
extends RefCounted

enum BehaviourType {WALK, RUN, STEALTH}

var source: Vector2
var destination: Vector2
var behaviour : BehaviourType
var cost : float

func _init(_source:Vector2, _destination:Vector2, _behavior:BehaviourType, _cost:float) -> void:
	source = _source
	destination = _destination
	behaviour = _behavior
	cost = _cost
