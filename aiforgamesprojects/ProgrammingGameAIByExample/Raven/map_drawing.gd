class_name MapDrawing
extends Node2D


enum tool_state {NONE, WALL, SPAWNS}
enum ui_state {MAP_EDITOR, MAP_RUNNING}

var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var mouse_in := true
var width := 0.0
var height := 0.0
var graph: RavenGraph

var current_state: tool_state = tool_state.NONE
var current_ui_state: ui_state = ui_state.MAP_EDITOR

var cell_size
var cell_space

func _process(delta: float) -> void:
	queue_redraw()
	if current_state == tool_state.WALL:
		if Input.is_action_pressed("place"):
			var wall_location = position_to_grid(get_global_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			#var cell_x = int(wall_location.y/cell_size)
			#var cell_y = int(wall_location.x/cell_size)
			#var key = Vector2i(cell_x, cell_y)
			#print(cell_space[key])
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.WALL
				graph.remove_wall(node.id)
		elif Input.is_action_pressed("remove"):
			var wall_location = position_to_grid(get_global_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.WALL and !node.is_border:
				node.node_type = RavenNode.NodeType.TRAVERSAL
				for k in range(-1, 2):
					for l in range(-1, 2):
						var neighbor: RavenNode = grid_world[node.node_pos.y+k][node.node_pos.x+l]
						if neighbor.node_type == RavenNode.NodeType.WALL:
							continue
						graph.add_edge(node.id, neighbor.id, 1.0)
	elif current_state == tool_state.SPAWNS:
		if Input.is_action_pressed("place"):
			var wall_location = position_to_grid(get_global_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.SPAWN
				print("spawn added")
				print("mous pos: ", get_global_mouse_position())
				print("grid_loc ", wall_location)
		elif Input.is_action_pressed("remove"):
			var wall_location = position_to_grid(get_global_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.SPAWN:
				node.node_type = RavenNode.NodeType.TRAVERSAL


func _draw() -> void:
	var mouse_pos = position_to_grid(get_global_mouse_position())
	var cell_x = int(mouse_pos.x/cell_size)
	var cell_y = int(mouse_pos.y/cell_size)
	var key = Vector2i(cell_x, cell_y)
	var current_cell_space:Array = cell_space[key]
	
	# Iterate the grid world and draw the correct color for the node type
	if !grid_world.is_empty():
		for row in range(rows):
			for col in range(columns):
				var node: RavenNode = grid_world[row][col]
				var neighbors : Array
				var color
				if node.node_type == RavenNode.NodeType.TRAVERSAL:
					draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), Color.WHITE)
					#draw_circle(node.node_pos, 2.0, Color.REBECCA_PURPLE)
					neighbors = graph.edges[node.id]
					
				elif node.node_type == RavenNode.NodeType.SPAWN:
					draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), Color.WHITE)
					draw_circle(grid_to_world(node.node_pos.x, node.node_pos.y, resolution), 4.0, Color.REBECCA_PURPLE)
					neighbors = graph.edges[node.id]
				else:
					draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), Color.BLACK)
				
				if current_cell_space.has(node):
					draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), Color(1.2, 1, 0, 0.4))
					print("Has node: ")
					print(node)
				
				if !neighbors.is_empty():
					for neighbor: GraphEdge in neighbors:
						
						var node_row = neighbor.to / columns
						var node_col = neighbor.to % columns
						var current_neighbor: RavenNode = grid_world[node_row][node_col]
						draw_line(grid_to_world(node.node_pos.x, node.node_pos.y, resolution), grid_to_world(current_neighbor.node_pos.x, current_neighbor.node_pos.y, resolution), Color.WEB_GREEN)
	
	## DRAW THE MOUSE POS
	if current_ui_state == ui_state.MAP_EDITOR:
		if mouse_in:
			var mouse_position:= get_global_mouse_position()
			var mouse_grid = position_to_grid(mouse_position)
			var color = Color.CRIMSON
			color.a = 0.5
			draw_rect(Rect2(mouse_grid.x * resolution, mouse_grid.y * resolution, resolution, resolution), color)
		# Draw the Grid rows and columns:
		for i in range(rows + 1):
			var y = i * resolution
			draw_line(Vector2(0, y), Vector2(width, y), Color.RED, 1.0)
		
		for c in range(columns + 1):
			var x = c * resolution
			draw_line(Vector2(x, 0), Vector2(x, height), Color.RED, 1.0)



func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)


func grid_to_world(col:int, row:int, res: float) -> Vector2:
	return Vector2(
		col * res + res / 2,
		row * res + res / 2
	)

func update_tool_state(state: tool_state) -> void:
	current_state = state
