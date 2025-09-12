class_name RavenAgent
extends Node2D


var path_planner : RavenPathPlanner
var click_radius := 15.0
var selected := false

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if selected:
		draw_circle(Vector2.ZERO, 10.0, Color(1.0, 0.3, 0.4, 0.6), true)
	draw_circle(Vector2.ZERO, 4.0, Color.GOLD)
	draw_line(Vector2.ZERO, Vector2(10.0,0.0), "red")


func _on_generate_paths_pressed() -> void:
	#print("getting random node")
	#print(path_planner.graph.get_random_node())
	#print("agent grid pos:")
	#print(path_planner.position_to_grid(position))
	#print("getting node:")
	#print(path_planner.get_nearest_node(position).id)
	print("getting random path:")
	print(path_planner.get_random_path(position))
