class_name SheepState
extends Node2D

signal state_transition_requested(new_state: Sheep.State)


var sheep : Sheep = null
var steering_controller : SheepSteeringController 

func setup(context_sheep, context_steering_controller) -> void:
	sheep = context_sheep
	steering_controller = context_steering_controller

func transition_state(new_state: Sheep.State) -> void:
	state_transition_requested.emit(new_state)
