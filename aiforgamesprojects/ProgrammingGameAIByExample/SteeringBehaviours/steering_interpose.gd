class_name SteeringInterpose
extends SteeringState

const DecelerationTweaker := 0.3

var decleration_factor := Vehicle.Deceleration.FAST

var mid_point_draw := Vector2.ZERO
var mid_point := Vector2.ZERO

func _enter_tree() -> void:
	print(interpose_target_1)
	print(interpose_target_2)


func _physics_process(delta: float) -> void:
	mid_point = (interpose_target_1.position + interpose_target_2.position) / 2.0
	var time_to_reach_mid_point = vehicle.position.distance_to(mid_point) / vehicle.max_speed
	
	var a_pos = interpose_target_1.position + interpose_target_1.velocity * time_to_reach_mid_point
	var b_pos = interpose_target_2.position + interpose_target_2.velocity * time_to_reach_mid_point
	
	mid_point_draw = (a_pos + b_pos) / 2.0
	
	var to_target = mid_point_draw - vehicle.position
	var dist := to_target.length()
	
	if dist > 0:
		var speed : float = dist / float(decleration_factor) * DecelerationTweaker
		speed = clamp(speed, 0.0, vehicle.max_speed)
		
		var desired_velocity = to_target * speed / dist
		var steering = (desired_velocity - vehicle.velocity).limit_length(vehicle.max_force)
		vehicle.apply_force(steering)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(to_local(mid_point), 8.0, "red")
