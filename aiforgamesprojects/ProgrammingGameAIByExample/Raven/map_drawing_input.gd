class_name MapDrawingInput
extends Node2D

enum tool_state {NONE, WALL, SPAWNS, WEAPONS}
enum ui_state {MAP_EDITOR, MAP_RUNNING, MAP_SELECTIONS}

@onready var drawer := $SubViewport/MapDrawing
@onready var viewport := $SubViewport

var mouse_in := true
var selected_position

var current_state: tool_state = tool_state.NONE
var current_ui_state: ui_state = ui_state.MAP_EDITOR

var pos : Vector2


var key
var last_key : Vector2i


func _ready() -> void:
	RavenServiceBus.mode_changed.connect(_on_mode_changed.bind())
	RavenServiceBus.submitted_weapon.connect(_on_submitted.bind())
	RavenServiceBus.grid_generated.connect(_on_grid_generated.bind())


func _on_grid_generated() -> void:
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	drawer.dirty_nodes = World.graph.nodes.duplicate()
	drawer.queue_redraw()

func _on_mode_changed(mode: tool_state) -> void:
	print(mode)
	current_state = mode

func _on_submitted(weapon: RavenNodeItemWeapon.WeaponSubtype) -> void:
	if RavenServiceBus.selected_node:
		var item := RavenNodeItemWeapon.new(weapon)
		RavenServiceBus.selected_node.set_item_type(item)
		RavenServiceBus.selected_node = null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		#print(drawer.dirty_nodes)
		print(World.graph.nodes)



func _process(delta: float) -> void:
	if current_state == tool_state.WALL:
		if Input.is_action_pressed("place"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.WALL
				#World.graph.remove_wall(node.id)
			drawer.dirty_nodes.append(node)
			drawer.queue_redraw()
			#World.graph.remove_wall(node.id) 
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
			drawer.dirty_nodes.append(node)
			drawer.queue_redraw()
	elif current_state == tool_state.SPAWNS:
		if Input.is_action_pressed("place"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				node.node_type = RavenNode.NodeType.SPAWN
			drawer.dirty_nodes.append(node)
			drawer.queue_redraw()
		elif Input.is_action_pressed("remove"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.SPAWN:
				node.node_type = RavenNode.NodeType.TRAVERSAL
			drawer.dirty_nodes.append(node)
			drawer.queue_redraw()
	elif current_state == tool_state.WEAPONS:
		if Input.is_action_just_pressed("place"):
			var wall_location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[wall_location.y][wall_location.x]
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				selected_position = wall_location
				current_state = tool_state.NONE
				RavenServiceBus.selected_node =node
				RavenServiceBus.weapon_popup.emit()
			drawer.dirty_nodes.append(node)
			drawer.queue_redraw()
	

func update_tool_state(state: tool_state) -> void:
	current_state = state
