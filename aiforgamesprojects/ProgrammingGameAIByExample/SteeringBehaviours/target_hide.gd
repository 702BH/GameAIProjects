class_name TargetHide
extends TargetState


const DISTANCE_BOUNDARY := 30.0

const DecelerationTweaker := 0.3

func _physics_process(delta: float) -> void:
	var distance_to_closest = INF
	
	var best_hiding_spot := Vector2.ZERO
	
	for obstacle:Obstacle in obstacles:
		var hiding_spot = get_hiding_spot(DISTANCE_BOUNDARY, obstacle.radius, obstacle.position, pursuer.position)
		var dist = hiding_spot.distance_squared_to(vehicle.position)
		if dist < distance_to_closest:
			distance_to_closest = dist
			best_hiding_spot = hiding_spot
	
	if distance_to_closest == INF:
		state_transition_requested.emit(Target.State.FLEEING)
	
	var to_target := best_hiding_spot - vehicle.position
	var dist := to_target.length()
	
	if dist > 0:
		var speed : float = dist / float(Target.Deceleration.FAST) * DecelerationTweaker
		speed = clamp(speed, 0.0, vehicle.max_speed)
		
		var desired_velocity := to_target * speed / dist
		
		vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
	
	if pursuer.position.distance_squared_to(vehicle.position) < vehicle.PANIC_DISTANCE * vehicle.PANIC_DISTANCE:
		if randf() < 0.5:
			state_transition_requested.emit(Target.State.FLEEING)
		else:
			state_transition_requested.emit(Target.State.EVADE)
