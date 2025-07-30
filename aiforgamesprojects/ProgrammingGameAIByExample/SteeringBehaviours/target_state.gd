class_name TargetState
extends Node

signal state_transition_requested(new_state: Target.State)



var vehicle : Target = null
var pursuer : Vehicle = null
var obstacles : Array[Obstacle] = []

func setup(context_vehicle: Target, context_pursuer : Vehicle, context_obstacles : Array[Obstacle]) ->void:
	vehicle = context_vehicle
	pursuer = context_pursuer
	obstacles = context_obstacles


func get_hiding_spot(distance_boundary: float, object_radius : float, object_position: Vector2, target_position: Vector2) -> Vector2:
	var hiding_spot :=Vector2.ZERO
	
	var distance_away = object_radius + distance_boundary
	
	var to_object  = (object_position - target_position).normalized()
	
	var heading_position = (to_object * distance_away) + object_position
	
	return heading_position
