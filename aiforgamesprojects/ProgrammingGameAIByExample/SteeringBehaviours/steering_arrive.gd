class_name SteeringArrive
extends SteeringState

const DecelerationTweaker := 0.3


var selected_dec

func _ready() -> void:
	selected_dec = vehicle.deceleration_factor

func _physics_process(delta: float) -> void:
	var to_target := target.position - vehicle.position
	var dist := to_target.length()
	
	if dist > 0:
		var speed : float = dist / float(selected_dec) * DecelerationTweaker
		speed = clamp(speed, 0.0, vehicle.max_speed)
		
		var desired_velocity := to_target * speed / dist
		
		vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))
