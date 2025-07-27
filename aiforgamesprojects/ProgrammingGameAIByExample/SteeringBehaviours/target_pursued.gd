class_name TargetPursued
extends TargetState



func _enter_tree() -> void:
	print("PURSUED")
	vehicle.velocity = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	vehicle.velocity = vehicle.velocity * vehicle.max_speed
	vehicle.velocity = vehicle.velocity.limit_length(vehicle.max_speed)

func _physics_process(delta: float) -> void:
	if pursuer.position.distance_squared_to(vehicle.position) < vehicle.PANIC_DISTANCE * vehicle.PANIC_DISTANCE:
		if randf() < 0.5:
			state_transition_requested.emit(Target.State.FLEEING)
		else:
			state_transition_requested.emit(Target.State.EVADE)
