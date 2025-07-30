class_name SteeringSeek
extends SteeringState



func _physics_process(delta: float) -> void:
	var desired_velocity : Vector2 = (target.position - vehicle.position).normalized() * vehicle.max_speed
	vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
	
	if vehicle.position.distance_squared_to(target.position) < vehicle.PANIC_DISTANCE * vehicle.PANIC_DISTANCE:
		transition_state(Vehicle.State.FLEE)
