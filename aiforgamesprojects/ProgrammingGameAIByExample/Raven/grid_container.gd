class_name GridDrawing
extends Control

enum tool_state {NONE, WALL, SPAWNS}
enum ui_state {MAP_EDITOR, MAP_RUNNING}

var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var mouse_in := false
var control

var current_state: tool_state = tool_state.NONE
var current_ui_state: ui_state = ui_state.MAP_EDITOR

func _process(delta: float) -> void:
	queue_redraw()
	if !mouse_in:
		return
	if current_state == tool_state.WALL:
		if Input.is_action_pressed("place"):
			var wall_location = position_to_grid(get_local_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.WALL
		elif Input.is_action_pressed("remove"):
			var wall_location = position_to_grid(get_local_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.WALL and !node.is_border:
				node.node_type = RavenNode.NodeType.TRAVERSAL
	elif current_state == tool_state.SPAWNS:
		if Input.is_action_pressed("place"):
			var wall_location = position_to_grid(get_local_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.SPAWN
		elif Input.is_action_pressed("remove"):
			var wall_location = position_to_grid(get_local_mouse_position())
			var node: RavenNode = grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.SPAWN:
				node.node_type = RavenNode.NodeType.TRAVERSAL


func _draw() -> void:
	# Iterate the grid world and draw the correct color for the node type
	if !grid_world.is_empty():
		for row in range(rows):
			for col in range(columns):
				var node: RavenNode = grid_world[row][col]
				var color
				if node.node_type == RavenNode.NodeType.TRAVERSAL:
					draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), Color.WHITE)
					#draw_circle(node.node_pos, 2.0, Color.REBECCA_PURPLE)
				elif node.node_type == RavenNode.NodeType.SPAWN:
					draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), Color.WHITE)
					draw_circle(node.node_pos, 4.0, Color.REBECCA_PURPLE)
				else:
					draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), Color.BLACK)
	
	
	# DRAW THE MOUSE POS
	if current_ui_state == ui_state.MAP_EDITOR:
		if mouse_in:
			var mouse_position:= get_local_mouse_position()
			var mouse_grid = position_to_grid(mouse_position)
			var color = Color.CRIMSON
			color.a = 0.5
			draw_rect(Rect2(mouse_grid.x * resolution, mouse_grid.y * resolution, resolution, resolution), color)
		# Draw the Grid rows and columns:
		for i in range(rows + 1):
			var y = i * resolution
			draw_line(Vector2(0, y), Vector2(size.x, y), Color.RED, 1.0)
		
		for c in range(columns + 1):
			var x = c * resolution
			draw_line(Vector2(x, 0), Vector2(x, size.y), Color.RED, 1.0)



func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)


func _on_mouse_entered() -> void:
	mouse_in = true
	print(current_state)


func _on_mouse_exited() -> void:
	mouse_in = false


func update_tool_state(state: tool_state) -> void:
	current_state = state
