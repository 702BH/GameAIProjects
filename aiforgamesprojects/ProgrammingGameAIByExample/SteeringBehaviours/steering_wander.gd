class_name  SteeringWander
extends SteeringState


var wanderRadius := 50.0
var wanderDistance := 100.0
var wanderJitter := 0.0
var wanderPoint := Vector2.ZERO
var theta = 0.0

func _enter_tree() -> void:
	vehicle.acceleration = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	var direction = vehicle.velocity.normalized()
	wanderPoint = direction * wanderDistance


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_circle(wanderPoint, wanderRadius, "green", false)
	var x = wanderRadius * cos(theta)
	var y = wanderRadius * sin(theta)
	draw_circle(Vector2(wanderPoint.x + x, wanderPoint.y + y), 8, "red")
