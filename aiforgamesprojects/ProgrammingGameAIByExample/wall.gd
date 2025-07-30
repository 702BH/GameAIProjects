class_name Wall
extends Node2D


func _ready() -> void:
	$Area2D/CollisionShape2D.shape.b = Vector2(randf_range(30.0,100.0) ,0)
	position = Vector2(randf_range(50, get_window().size.x -50), randf_range(50, get_window().size.y -50))
	rotate(randf_range(PI, PI/2))
