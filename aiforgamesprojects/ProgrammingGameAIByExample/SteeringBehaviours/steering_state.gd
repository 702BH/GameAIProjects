class_name SteeringState
extends Node2D

signal state_transition_requested(new_state: Vehicle.State, state_data : SteeringStateData)

var vehicle : Vehicle = null
var target : Target = null
var obstacles : Array[Obstacle] = []
var state_data : SteeringStateData = SteeringStateData.new()
var interpose_target_1 : Vehicle = null
var interpose_target_2 : Vehicle = null

func setup(context_vehicle: Vehicle, context_target: Target, context_obstacles, context_state_data, context_interpose_1, context_interpose_2) ->void:
	vehicle = context_vehicle
	target = context_target
	obstacles = context_obstacles
	state_data = context_state_data
	interpose_target_1 = context_interpose_1
	interpose_target_2 = context_interpose_2


func transition_state(new_state: Vehicle.State, state_data: SteeringStateData = SteeringStateData.new()) -> void:
	state_transition_requested.emit(new_state, state_data)


func get_obstacles_in_detector() -> Array[Obstacle]:
	var tagged_obstacles : Array[Obstacle] = []
	
	var closest_obstacle: Obstacle = null
	var dist_to_closest_ip = INF
	
	for area in vehicle.area.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Obstacle:
			#tagged_obstacles.append(parent)
			var local_pos = parent.global_position - vehicle.global_position
			local_pos = local_pos.rotated(-vehicle.rotation)
			
			if local_pos.x < 0 or abs(local_pos.y) > vehicle.radius:
				continue
			
			var expanded_radius = parent.radius + parent.collision_radius
			
			if abs(local_pos.y) >= expanded_radius:
				continue
			
			var sqrt_part = sqrt(expanded_radius * expanded_radius - local_pos.y * local_pos.y)
			var ip = local_pos.x - sqrt_part
			if ip <= 0:
				ip = local_pos.x + sqrt_part
			
			if ip <dist_to_closest_ip:
				dist_to_closest_ip = ip
				closest_obstacle = parent
	
	if closest_obstacle != null:
		tagged_obstacles.append(closest_obstacle)
	return tagged_obstacles


func wall_collisions() -> bool:
	return vehicle.feeler.is_colliding()
