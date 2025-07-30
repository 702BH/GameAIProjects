class_name SteeringObstacleAvoidance
extends SteeringState

const BRAKING_WEIGHT := 0.2
const SAFE_DISTANCE := 100.0


func _enter_tree() -> void:
	print("Avoiding")


func _physics_process(delta: float) -> void:
	var dist:= vehicle.position.distance_to(state_data.closest_obstacle.position)
	
	if dist > SAFE_DISTANCE:
		transition_state(Vehicle.State.PURSUE)
		return
	
	var desired_velocity = (vehicle.position - state_data.closest_obstacle.position).normalized() * vehicle.max_speed
	var steering = (desired_velocity - vehicle.velocity).limit_length(vehicle.max_force)
	vehicle.apply_force(steering)
