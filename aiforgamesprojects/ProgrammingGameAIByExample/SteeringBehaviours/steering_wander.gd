class_name  SteeringWander
extends SteeringState

var wanderRadius := 50.0
var wanderDistance := 100.0
var wanderJitter := 2
var wanderTarget := Vector2.ZERO
var targetLocal := Vector2.ZERO
var targetWorld := Vector2.ZERO

func _enter_tree() -> void:
	print("wandering")

func _physics_process(delta: float) -> void:
	wanderTarget += Vector2(randf_range(-1,1) * wanderJitter, randf_range(-1,1) * wanderJitter)
	wanderTarget = wanderTarget.normalized()
	wanderTarget *= wanderRadius
	targetLocal = wanderTarget + Vector2(wanderDistance, 0)
	targetWorld = targetLocal + vehicle.position
	var desired_velocity : Vector2 = (targetWorld - vehicle.position).normalized() * vehicle.max_speed
	vehicle.apply_force((desired_velocity - vehicle.velocity).limit_length(vehicle.max_force))


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_circle(targetLocal, wanderRadius, "green", false)
	draw_circle(wanderTarget + targetLocal, 8, "red")
