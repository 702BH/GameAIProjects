class_name NavGraphEdge
extends "res://ProgrammingGameAIByExample/Graphs/GraphEdge.gd"


enum BehaviourType {WALK, RUN, STEALTH}


var behaviour_type: BehaviourType

func _init(context_from:int, context_to:int, context_cost:float, _behaviour_type: BehaviourType = BehaviourType.WALK) -> void:
	super(context_from, context_to, context_cost)
	behaviour_type = _behaviour_type
