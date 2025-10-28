class_name MapDrawingInput
extends Node2D

enum tool_state {NONE, WALL, SPAWNS, WEAPONS, PLACEABLE}
enum ui_state {MAP_EDITOR, MAP_RUNNING, MAP_SELECTIONS}

@onready var drawer := $SubViewport/MapDrawing
@onready var viewport := $SubViewport
@onready var bucketdrawing := $BucketDrawing
@onready var static_drawing := $SubViewport/MapDrawing/StaticDrawing

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
	RavenServiceBus.placeable_popup_submitted.connect(_on_popup_submitted.bind())
	RavenServiceBus.debg_mode_changed.connect(_on_debug_mode_changed.bind())

func _on_debug_mode_changed(mode:bool) -> void:
	pass

func _on_popup_submitted(data: SelectableData) -> void:
	#print("Popup sucessfuly submitted")
	match data.placeable_type:
		SelectableData.PlaceableType.Health:
			#print("Health submitted")
			data.node.set_item_type(RavenNodeItemHealth.new())
			
		SelectableData.PlaceableType.Weapon:
			match data.weapon_sub_type:
				SelectableData.WeaponSubtype.SHOTGUN:
					data.node.set_item_type(RavenNodeItemWeapon.new(RavenNodeItem.ItemSubType.SHOTGUN))
				SelectableData.WeaponSubtype.ROCKET_LAUNCHER:
					data.node.set_item_type(RavenNodeItemWeapon.new(RavenNodeItem.ItemSubType.ROCKET_LAUNCHER))
				SelectableData.WeaponSubtype.BLASTER:
					data.node.set_item_type(RavenNodeItemWeapon.new(RavenNodeItem.ItemSubType.BLASTER))
				SelectableData.WeaponSubtype.RAIL_GUN:
					data.node.set_item_type(RavenNodeItemWeapon.new(RavenNodeItem.ItemSubType.RAIL_GUN))
			print("Weapon submitted")
		SelectableData.PlaceableType.Spawn:
			#print("Spawn submitted")
			if data.node.node_type == RavenNode.NodeType.TRAVERSAL:
				data.node.node_type = RavenNode.NodeType.SPAWN
	drawer.dirty_nodes.append(data.node)
	drawer.queue_redraw()

func _on_grid_generated() -> void:
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	for node in World.graph.nodes:
		drawer.dirty_nodes.append(node)
	#drawer.dirty_nodes = World.graph.nodes.duplicate()
	drawer.queue_redraw()

func _on_mode_changed(mode: tool_state) -> void:
	print(mode)
	current_state = mode
	print("MAP STATE CHANGED: ")
	print(current_state)

func _on_submitted(weapon: RavenNodeItem.ItemSubType) -> void:
	if RavenServiceBus.selected_node:
		var item := RavenNodeItemWeapon.new(weapon)
		RavenServiceBus.selected_node.set_item_type(item)
		RavenServiceBus.selected_node = null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		#print(drawer.dirty_nodes)
		#print(World.graph.nodes)
		pass



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
	elif current_state == tool_state.PLACEABLE:
		# We are in the placeable state
		if Input.is_action_pressed("place"):
			var location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[location.y][location.x]
			# if node is valid
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				current_state = tool_state.NONE
				selected_position = location
				var selectable_data := SelectableData.new()
				selectable_data.set_node(node)
				RavenServiceBus.placeable_popup_requested.emit(selectable_data)
		elif Input.is_action_pressed("remove"):
			var location = World.position_to_grid(get_global_mouse_position())
			var node: RavenNode = World.grid_world[location.y][location.x]
			if node.node_type != RavenNode.NodeType.WALL:
				node.node_type = RavenNode.NodeType.TRAVERSAL
				node.item_type = null
			drawer.dirty_nodes.append(node)
			drawer.queue_redraw()

func update_tool_state(state: tool_state) -> void:
	current_state = state
