class_name SteeringState
extends Node2D

signal state_transition_requested(new_state: Vehicle.State)

var vehicle : Vehicle = null
var target : Target = null
var obstacles : Array[Obstacle] = []

func setup(context_vehicle: Vehicle, context_target: Target, context_obstacles) ->void:
	vehicle = context_vehicle
	target = context_target
	obstacles = context_obstacles



func get_obstacles_in_detector() -> Array[Obstacle]:
	var tagged_obstacles : Array[Obstacle] = []
	
	var vel = vehicle.velocity.normalized()
	vel = vel * vehicle.detection_box_length
	
	
	for obstacle in obstacles:
		if obstacle.position.x + obstacle.collision_radius > vehicle.position.x - vehicle.radius and obstacle.position.x + obstacle.collision_radius < vehicle.position.x +  vel.x - vehicle.radius:
			if obstacle.position.y + obstacle.collision_radius > vehicle.position.y + vehicle.radius and obstacle.position.y + obstacle.collision_radius < vehicle.position.y +  vel.y + vehicle.radius:
				tagged_obstacles.append(obstacle)
	return tagged_obstacles
