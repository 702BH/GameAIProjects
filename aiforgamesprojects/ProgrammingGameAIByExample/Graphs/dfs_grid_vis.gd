extends Node2D




@onready var source_button := $Control/HBoxContainer/Buttons/Source
@onready var target_button := $Control/HBoxContainer/Buttons/Target
@onready var walls_button := $Control/HBoxContainer/Buttons/Walls
@onready var buttons_container := $Control/HBoxContainer/Buttons
@onready var grid: ReferenceRect= $Control/HBoxContainer/Grid
@onready var dfs_button := $Control/HBoxContainer/Buttons/dfs
@onready var bfs_button := $Control/HBoxContainer/Buttons/bfs

var graph: SparseGraph
var resolution := 30.0
var rows :=0
var columns := 0
var grid_world = []
var grid_size := Vector2.ZERO
var placing := false
var can_change := true

var source_node = null
var target_node = null

var dfs_path = []
var bfs_path = []


func _ready() -> void:
	graph = SparseGraph.new(false)
	grid.source_placed.connect(on_source_placed.bind())
	grid.target_placed.connect(on_target_placed.bind())
	if can_change:
		can_change = false
		grid_size = grid.custom_minimum_size
		rows = int(grid_size.y / resolution)
		columns = int(grid_size.x / resolution)
		grid_world.resize(rows)
		for i in range(rows):
			grid_world[i] = []
			for j in range(columns):
				graph.add_vertex()
				grid_world[i].append(graph.nodes[i * columns + j])
		for i in range(rows):
			for j in range(columns):
				var node = grid_world[i][j]
				if i == 0 or i == rows-1 or j== 0 or j==columns-1:
					graph.remove_vertex(node.id)
					grid_world[i][j] = null
					grid.walls.append(Vector2(i,j))
					continue
				#else, we need to add the edges
				#top left
				for k in range(-1, 2):
					for l in range(-1, 2):
						var neighbor = grid_world[i+k][j+l]
						if neighbor == null:
							continue
						graph.add_edge(node.id, neighbor.id, 0.0)
	#print(grid_world)
	#print(graph.edges)
	grid.graph = graph


func _process(delta: float) -> void:
	if grid.walls.is_empty():
		pass
	for wall in grid.walls:
		var node = grid_world[wall.x][wall.y]
		if node == null:
			continue
		graph.remove_vertex(node.id)
		grid_world[wall.x][wall.y] = null
		#print(node.id)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):#
		print(grid.walls.size())
		#print(graph.nodes)dd

func _on_source_toggled(toggled_on: bool) -> void:
	placing = toggled_on
	if toggled_on:
		disable_other_buttons(source_button)
		grid.placing_source = true
		print(placing)
	else:
		enable_buttons()
		


func enable_buttons() -> void:
	for child in buttons_container.get_children():
		child.disabled = false

func disable_other_buttons(selected_button: Button) -> void:
	for child in buttons_container.get_children():
		if child == selected_button:
			continue
		else:
			child.disabled = true


func on_source_placed() -> void:
	print("placed")
	source_button.button_pressed = false
	placing = false
	var loc = grid.source_location
	var node = grid_world[loc.y][loc.x]
	if node == null:
		return
	source_node = node
	print(source_node)
	if source_node != null and target_node != null:
		dfs_button.disabled = false
		bfs_button.disabled = false
	else:
		dfs_button.disabled = true
		bfs_button.disabled = true

func on_target_placed() -> void:
	target_button.button_pressed = false
	placing = false
	var loc = grid.target_location
	var node = grid_world[loc.y][loc.x]
	if node == null:
		return
	target_node = node
	print(target_node)
	if source_node != null and target_node != null:
		dfs_button.disabled = false
		bfs_button.disabled = false

func _on_target_toggled(toggled_on: bool) -> void:
	placing = toggled_on
	if toggled_on:
		disable_other_buttons(target_button)
		grid.placing_target = true
	else:
		enable_buttons()


func _on_walls_toggled(toggled_on: bool) -> void:
	placing= toggled_on
	grid.placing_walls = toggled_on
	if toggled_on:
		disable_other_buttons(walls_button)
		
	else:
		enable_buttons()


func _on_dfs_pressed() -> void:
	#grid.paths = []
	dfs_path = graph.depth_first_search_source(source_node.id, target_node.id)
	for node in dfs_path:
		pass


func _on_button_pressed() -> void:
	#grid.paths = []
	bfs_path = graph.breadth_first_search_source(source_node.id, target_node.id)
	
