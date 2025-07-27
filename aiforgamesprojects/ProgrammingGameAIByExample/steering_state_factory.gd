class_name SteeringStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Vehicle.State.SEEK : SteeringSeek,
		Vehicle.State.FLEE : SteeringFlee,
		Vehicle.State.ARRIVE : SteeringArrive,
		Vehicle.State.PURSUE : SteeringPursuing,
		Vehicle.State.WANDER : SteeringWander
	}

func get_fresh_state(state: Vehicle.State) -> SteeringState:
	assert(states.has(state), "State does not exist")
	return states.get(state).new()
