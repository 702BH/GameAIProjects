class_name SheepStateFactory
extends Node

var states : Dictionary

func _init() -> void:
	states = {
		Sheep.State.EATING : SheepStateEating,
		Sheep.State.SLEEPING : SheepStateSleeping,
		Sheep.State.SEEKING  : SheepStateSeeking
	}

func get_fresh_state(state: Sheep.State) -> SheepState:
	assert(states.has(state), "State does not exist")
	return states.get(state).new()
