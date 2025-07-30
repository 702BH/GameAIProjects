class_name  TargetFleeing
extends TargetState

func _enter_tree() -> void:
	print("FLEEING")

func _physics_process(delta: float) -> void:
	var desired_velocity : Vector2 = (vehicle.position - pursuer.position).normalized() * vehicle.flee_speed
	vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
	vehicle.velocity = vehicle.velocity.limit_length(vehicle.flee_speed)
	if pursuer.position.distance_squared_to(vehicle.position) > vehicle.SAFE_DISTANCE * vehicle.SAFE_DISTANCE:
		state_transition_requested.emit(Target.State.HIDE)
