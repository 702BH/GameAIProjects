class_name TargetEvade
extends TargetState



func _enter_tree() -> void:
	print("EVADING")


func _physics_process(delta: float) -> void:
	var to_pursuer = pursuer.position - vehicle.position
	
	var look_ahead_time = to_pursuer.length() / (vehicle.flee_speed + pursuer.max_speed)
	
	var future_position = pursuer.position  + pursuer.velocity * look_ahead_time
	
	var desired_velocity = (vehicle.position - future_position).normalized() * vehicle.flee_speed
	var steering = (desired_velocity - vehicle.velocity).limit_length(vehicle.flee_speed)
	
	vehicle.apply_force(steering)
	
	if pursuer.position.distance_squared_to(vehicle.position) > vehicle.SAFE_DISTANCE * vehicle.SAFE_DISTANCE:
		state_transition_requested.emit(Target.State.HIDE)
