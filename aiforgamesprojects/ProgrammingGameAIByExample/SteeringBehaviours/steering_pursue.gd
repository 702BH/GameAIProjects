class_name SteeringPursuing
extends SteeringState


func _enter_tree() -> void:
	print("PURSUING")

func _physics_process(delta: float) -> void:
	
	var tagged_obstacles : Array[Obstacle] = []
	tagged_obstacles = get_obstacles_in_detector()
	
	if !tagged_obstacles.is_empty():
		var state_data := SteeringStateData.new()
		state_data.closest_obstacle = tagged_obstacles[0]
		transition_state(Vehicle.State.OBSTACLE_AVOIDANCE, state_data)
	else:
		print("NO OBSTACLES")
	
	
	var to_evader = target.position - vehicle.position
	var relative_heading = vehicle.velocity.normalized().dot(target.velocity.normalized())
	
	if(to_evader.dot(vehicle.velocity.normalized()) > 0 ) && relative_heading < -0.95:
		var desired_velocity : Vector2 = (target.position - vehicle.position).normalized() * vehicle.max_speed
		vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
	
	var look_ahead_time = to_evader.length() / (vehicle.max_speed + target.velocity.length()) 
	
	var future_position = target.position  + target.velocity * look_ahead_time
	
	var desired_velocity = (future_position - vehicle.position).normalized() * vehicle.max_speed
	var steering = (desired_velocity - vehicle.velocity).limit_length(vehicle.max_force)
	
	vehicle.apply_force(steering)
