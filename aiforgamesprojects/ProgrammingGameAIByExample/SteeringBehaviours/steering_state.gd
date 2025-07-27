class_name SteeringState
extends Node2D

signal state_transition_requested(new_state: Vehicle.State)

var vehicle : Vehicle = null
var target : Target = null

func setup(context_vehicle: Vehicle, context_target: Target) ->void:
	vehicle = context_vehicle
	target = context_target
