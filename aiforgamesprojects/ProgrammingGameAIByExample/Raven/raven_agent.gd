class_name RavenAgent
extends Node2D


var path_planner : RavenPathPlanner

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, Color.GOLD)
	draw_line(Vector2.ZERO, Vector2(10.0,0.0), "red")
