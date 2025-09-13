class_name RavenAgent
extends Node2D


var path_planner : RavenPathPlanner
var click_radius := 15.0
var selected := false

var current_path = []

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if selected:
		draw_circle(Vector2.ZERO, 10.0, Color(1.0, 0.3, 0.4, 0.6), true)
	draw_circle(Vector2.ZERO, 4.0, Color.GOLD)
	draw_line(Vector2.ZERO, Vector2(10.0,0.0), "red")
	if !current_path.is_empty():
		#print("drawing target:")
		var target_node:RavenNode = current_path[current_path.size()-1]
		
		draw_circle(to_local(grid_to_world(target_node.node_pos.x, target_node.node_pos.y, path_planner.resolution)), 6.0, Color.NAVY_BLUE)
		draw_line(Vector2.ZERO, to_local(grid_to_world(current_path[0].node_pos.x, current_path[0].node_pos.y, path_planner.resolution)), "orange")
		for i in range(1, current_path.size() - 1):
			if i == current_path.size() - 1:
				continue
			else:
				draw_line(to_local(grid_to_world(current_path[i].node_pos.x, current_path[i].node_pos.y, path_planner.resolution)), to_local(grid_to_world(current_path[i+1].node_pos.x, current_path[i+1].node_pos.y, path_planner.resolution)), "orange")

func _on_generate_paths_pressed() -> void:
	current_path.clear()
	#print("getting random node")
	#print(path_planner.graph.get_random_node())
	#print("agent grid pos:")
	#print(path_planner.position_to_grid(position))
	#print("getting node:")
	#print(path_planner.get_nearest_node(position).id)
	print("getting random path:")
	#print(path_planner.get_random_path(position))
	current_path = path_planner.get_random_path(position)
	print(current_path[current_path.size()-1].node_pos)



func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / path_planner.resolution), 0, path_planner.columns - 1)
	var row = clamp(int(pos.y / path_planner.resolution) , 0 , path_planner.rows - 1)
	return Vector2(col, row)


func grid_to_world(col:int, row:int, res: float) -> Vector2:
	return Vector2(
		col * res + res / 2,
		row * res + res / 2
	)
