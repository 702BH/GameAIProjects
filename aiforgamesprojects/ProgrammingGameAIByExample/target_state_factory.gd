class_name TargetStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Target.State.STATIC : TargetStatic,
		Target.State.PURSUED : TargetPursued,
		Target.State.FLEEING : TargetFleeing,
		Target.State.EVADE : TargetEvade
	}

func get_fresh_state(state: Target.State) -> TargetState:
	assert(states.has(state), "State does not exist")
	return states.get(state).new()
