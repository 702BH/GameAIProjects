class_name SteeringWallAvoidance
extends SteeringState

var steering_force := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# if wall
	if wall_collisions():
		var normal = vehicle.feeler.get_collision_normal()
		var desired_velocity : Vector2 = normal.normalized() * vehicle.max_speed
		desired_velocity = (desired_velocity - vehicle.velocity).limit_length(vehicle.max_force)
		steering_force += desired_velocity * 1.8
		#vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))

	var desired_velocity : Vector2 = (target.position - vehicle.position).normalized() * vehicle.max_speed
	desired_velocity = (desired_velocity - vehicle.velocity).limit_length(vehicle.max_force)
	steering_force += desired_velocity
	#vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
	vehicle.apply_force(steering_force)
