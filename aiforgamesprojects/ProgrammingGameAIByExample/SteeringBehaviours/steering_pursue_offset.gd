class_name SteeringPursueOffset
extends SteeringState


var offset_position

const DecelerationTweaker := 0.3

func _physics_process(delta: float) -> void:
	offset_position = leader.position +  leader.velocity.normalized() * -15.0
	
	var to_offset = offset_position - vehicle.position
	
	var look_ahead_time = to_offset.length() / (vehicle.max_speed + leader.velocity.length())
	
	var future_position = offset_position  + leader.velocity * look_ahead_time
	
	var desired_velocity = (future_position - vehicle.position).normalized() * vehicle.max_speed
	var steering = (desired_velocity - vehicle.velocity).limit_length(vehicle.max_force)
	
	vehicle.apply_force(steering)
