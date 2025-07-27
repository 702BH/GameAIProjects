class_name TargetState
extends Node

signal state_transition_requested(new_state: Target.State)

var vehicle : Target = null
var pursuer : Vehicle = null

func setup(context_vehicle: Target, context_pursuer : Vehicle) ->void:
	vehicle = context_vehicle
	pursuer = context_pursuer
