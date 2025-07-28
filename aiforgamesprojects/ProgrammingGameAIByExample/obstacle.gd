class_name Obstacle
extends Node2D


var radius := randi_range(10, 30)
var color : Color
var collision_radius := 5.0

func _enter_tree() -> void:
	position = Vector2(randf_range(50, get_window().size.x -50), randf_range(50, get_window().size.y -50))


func _ready() -> void:
	color = Color.from_rgba8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255), 255)
	$Area2D/CollisionShape2D.shape.radius = collision_radius

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
