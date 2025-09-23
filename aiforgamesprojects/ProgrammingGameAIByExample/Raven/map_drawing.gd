class_name MapDrawing
extends Node2D


enum tool_state {NONE, WALL, SPAWNS, WEAPONS}
enum ui_state {MAP_EDITOR, MAP_RUNNING, MAP_SELECTIONS}


var mouse_in := true

var current_state: tool_state = tool_state.NONE
var current_ui_state: ui_state = ui_state.MAP_EDITOR


var selected_position

func _ready() -> void:
	RavenServiceBus.mode_changed.connect(_on_mode_changed.bind())
	RavenServiceBus.submitted_weapon.connect(_on_submitted.bind())

func _on_mode_changed(mode: tool_state) -> void:
	print(mode)
	current_state = mode

func _on_submitted(weapon: RavenNodeItemWeapon.WeaponSubtype) -> void:
	if RavenServiceBus.selected_node:
		var item := RavenNodeItemWeapon.new(weapon)
		RavenServiceBus.selected_node.set_item_type(item)
		RavenServiceBus.selected_node = null

func _process(delta: float) -> void:
	if current_state == tool_state.WALL:
		if Input.is_action_pressed("place"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.WALL
				World.graph.remove_wall(node.id)
			queue_redraw()
		elif Input.is_action_pressed("remove"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.WALL and !node.is_border:
				node.node_type = RavenNode.NodeType.TRAVERSAL
				for k in range(-1, 2):
					for l in range(-1, 2):
						var neighbor: RavenNode = World.grid_world[node.node_pos.y+k][node.node_pos.x+l]
						if neighbor.node_type == RavenNode.NodeType.WALL:
							continue
						World.graph.add_edge(node.id, neighbor.id, 1.0)
			queue_redraw()
	elif current_state == tool_state.SPAWNS:
		if Input.is_action_pressed("place"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.SPAWN
			queue_redraw()
		elif Input.is_action_pressed("remove"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.SPAWN:
				node.node_type = RavenNode.NodeType.TRAVERSAL
			queue_redraw()
	elif current_state == tool_state.WEAPONS:
		if Input.is_action_just_pressed("place"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				selected_position = wall_location
				current_state = tool_state.NONE
				RavenServiceBus.selected_node =node
				RavenServiceBus.weapon_popup.emit()
			queue_redraw()


func _draw() -> void:
	var mouse_pos = World.position_to_grid(get_global_mouse_position())
	var cell_x = int(mouse_pos.x/World.cell_size)
	var cell_y = int(mouse_pos.y/World.cell_size)
	var key = Vector2i(cell_x, cell_y)
	var current_cell_space = World.cell_buckets_static.get(key, [])
	# Iterate the grid world and draw the correct color for the node type
	if !World.grid_world.is_empty():
		for row in range(World.rows):
			for col in range(World.columns):
				var node: RavenNode = World.grid_world[row][col]
				var neighbors : Array
				var color
				if node.node_type == RavenNode.NodeType.TRAVERSAL:
					draw_rect(Rect2(col * World.resolution, row * World.resolution, World.resolution, World.resolution), Color.WHITE)
					#draw_circle(node.node_pos, 2.0, Color.REBECCA_PURPLE)
					neighbors = World.graph.edges[node.id]
					if node.item_type:
						if node.item_type.item_type == RavenNodeItem.ItemType.WEAPON:
							draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 6.0, Color.CRIMSON)
					
				elif node.node_type == RavenNode.NodeType.SPAWN:
					draw_rect(Rect2(col * World.resolution, row * World.resolution, World.resolution, World.resolution), Color.WHITE)
					draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 4.0, Color.REBECCA_PURPLE)
					neighbors = World.graph.edges[node.id]
				else:
					draw_rect(Rect2(col * World.resolution, row * World.resolution, World.resolution, World.resolution), Color.BLACK)
				
				if current_cell_space.has(node):
					draw_rect(Rect2(col * World.resolution, row * World.resolution, World.resolution, World.resolution), Color(1.2, 1, 0, 0.4))
					#print("Has node: ")
					#print(node)
				
				if !neighbors.is_empty():
					for neighbor: GraphEdge in neighbors:
						
						var node_row = neighbor.to / World.columns
						var node_col = neighbor.to % World.columns
						var current_neighbor: RavenNode = World.grid_world[node_row][node_col]
						draw_line(World.grid_to_world(node.node_pos.x, node.node_pos.y), World.grid_to_world(current_neighbor.node_pos.x, current_neighbor.node_pos.y), Color.WEB_GREEN)
	
	## DRAW THE MOUSE POS
	if current_ui_state == ui_state.MAP_EDITOR:
		if mouse_in:
			var mouse_position:= get_global_mouse_position()
			var mouse_grid = World.position_to_grid(mouse_position)
			var color = Color.CRIMSON
			color.a = 0.5
			draw_rect(Rect2(mouse_grid.x * World.resolution, mouse_grid.y * World.resolution, World.resolution, World.resolution), color)
		# Draw the Grid rows and columns:
		for i in range(World.rows + 1):
			var y = i * World.resolution
			draw_line(Vector2(0, y), Vector2(World.width, y), Color.RED, 1.0)
		
		for c in range(World.columns + 1):
			var x = c * World.resolution
			draw_line(Vector2(x, 0), Vector2(x, World.height), Color.RED, 1.0)


func update_tool_state(state: tool_state) -> void:
	current_state = state
