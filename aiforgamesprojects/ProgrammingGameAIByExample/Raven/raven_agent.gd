class_name RavenAgent
extends Node2D


var path_planner : RavenPathPlanner
var click_radius := 15.0
var selected := false

var current_path = []

var edge_timer := 0
var exepected_time := 0.0

var max_speed := 200

func _process(delta: float) -> void:
	queue_redraw()
	if !current_path.is_empty():
		
		if edge_timer == 0:
			edge_timer = Time.get_ticks_msec()
			exepected_time = (current_path[0].cost / max_speed + 2.0) * 1000.0
		
		var elapsed := Time.get_ticks_msec() - edge_timer
		if elapsed > exepected_time:
			print("Time passed, recalculating")
			_on_generate_paths_pressed()
			edge_timer = 0

func _draw() -> void:
	if selected:
		draw_circle(Vector2.ZERO, 10.0, Color(1.0, 0.3, 0.4, 0.6), true)
	draw_circle(Vector2.ZERO, 4.0, Color.GOLD)
	draw_line(Vector2.ZERO, Vector2(10.0,0.0), "red")
	if !current_path.is_empty():
		#print("drawing target:")
		var target_node:PathEdge = current_path[current_path.size()-1]
		
		draw_circle(to_local(World.grid_to_world(target_node.destination.x, target_node.destination.y)), 6.0, Color.NAVY_BLUE)
		#draw_line(Vector2.ZERO, to_local(grid_to_world(current_path[0].node_pos.x, current_path[0].node_pos.y, path_planner.resolution)), "orange")
		for edge:PathEdge in current_path:
			var color := Color.ORANGE
			draw_line(to_local(World.grid_to_world(edge.source.x, edge.source.y)), to_local(World.grid_to_world(edge.destination.x, edge.destination.y)), color)
		
		#for i in range(0, current_path.size() - 1):
			#if i == current_path.size() - 1:
				#continue
			#else:
				#draw_line(to_local(grid_to_world(current_path[i].node_pos.x, current_path[i].node_pos.y, path_planner.resolution)), to_local(grid_to_world(current_path[i+1].node_pos.x, current_path[i+1].node_pos.y, path_planner.resolution)), "orange")

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
	edge_timer = 0
	#follow_path(current_path)
	


func follow_path(path:Array) -> void:
	if path.is_empty():
		return
