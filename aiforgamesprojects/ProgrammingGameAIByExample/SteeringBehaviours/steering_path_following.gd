class_name SteeringPathFollowing
extends SteeringState

const WAYPOINT_SEEK_DISTANCE := 200.0

const DecelerationTweaker := 0.3


var selected_dec



var current_way_point : Vector2

func _enter_tree() -> void:
	selected_dec = Vehicle.Deceleration.NORMAL
	if !path.points.is_empty():
		current_way_point = path.get_next_way_point()
	else:
		transition_state(Vehicle.State.WANDER)


func _physics_process(delta: float) -> void:
	if current_way_point == Vector2.ZERO:
		if path.is_finished():
			transition_state(Vehicle.State.WANDER)
		else:
			current_way_point = path.get_next_way_point()
		return
	# Arrive towards current way point
	var to_target := current_way_point - vehicle.position
	var dist := to_target.length()
	if dist > 0:
		var speed : float = dist / float(selected_dec) * DecelerationTweaker
		speed = clamp(speed, 0.0, vehicle.max_speed)
		
		var desired_velocity := to_target * speed / dist
		
		vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
	
	if dist < WAYPOINT_SEEK_DISTANCE:
		current_way_point = path.get_next_way_point()
	
	if current_way_point == Vector2.ZERO:
		transition_state(Vehicle.State.WANDER)
