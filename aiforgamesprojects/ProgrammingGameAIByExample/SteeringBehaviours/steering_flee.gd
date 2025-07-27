class_name  SteeringFlee
extends SteeringState


func _physics_process(delta: float) -> void:
	var desired_velocity : Vector2 = (vehicle.position - target.position).normalized() * vehicle.max_speed
	vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
