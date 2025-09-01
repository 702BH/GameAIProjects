extends Control

@onready var grid_container := $Container/GridContainer

var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var graph: RavenGraph
var loaded_map := ""


func _ready() -> void:
	graph = RavenGraph.new(false)
	generate_grid()
	initialise_grid_container(rows, columns, resolution, grid_world)
	print(grid_world[2][5])

func generate_grid() -> void:
	rows = int(grid_container.size.y / resolution)
	columns = int(grid_container.size.x / resolution)
	grid_world.resize(rows)
	for i in range(rows):
		grid_world[i] = []
		for j in range(columns):
			if i == 0 or i == rows-1 or j== 0 or j==columns-1:
				graph.add_vertex(RavenNode.NodeType.WALL, Vector2(j * resolution + resolution / 2, i * resolution + resolution / 2), true)
				grid_world[i].append(graph.nodes[i * columns + j])
			else:
				graph.add_vertex(RavenNode.NodeType.TRAVERSAL, Vector2(j * resolution + resolution / 2, i * resolution + resolution / 2), false)
				grid_world[i].append(graph.nodes[i * columns + j])


func initialise_grid_container(_rows:int, _columns:int, _res:float, _grid:Array) -> void:
	grid_container.rows = _rows
	grid_container.columns = _columns
	grid_container.resolution = _res
	grid_container.grid_world = _grid
	grid_container.queue_redraw()


func _on_walls_toggled(toggled_on: bool) -> void:
	if toggled_on:
		grid_container.update_tool_state(GridDrawing.tool_state.WALL)
	else:
		grid_container.update_tool_state(GridDrawing.tool_state.NONE)


func _on_spawn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		grid_container.update_tool_state(GridDrawing.tool_state.SPAWNS)
	else:
		grid_container.update_tool_state(GridDrawing.tool_state.NONE)


func _on_save_pressed() -> void:
	var save_data = {
		"rows":rows,
		"columns": columns,
		"resolution": resolution,
		"nodes": []
	}
	for row in range(rows):
		for col in range(columns):
			var node: RavenNode = grid_world[row][col]
			save_data["nodes"].append({
				"type": node.node_type,
				"position": {"x":node.node_pos.x, "y":node.node_pos.y},
				"row": row,
				"column": col
			})
	
	var file_path = "res://ProgrammingGameAIByExample/Raven/Maps/" + str($Container/ButtonPanel/Buttons/MapName.text + ".json")
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_line(json_string)
	file.close()


func _on_load_pressed() -> void:
	$LoadMapDialog.root_subfolder = "res://ProgrammingGameAIByExample/Raven/Maps/"
	$LoadMapDialog.popup_centered()


func _on_load_map_dialog_file_selected(path: String) -> void:
	$LoadMapDialog.hide()
	loaded_map = path
	print(loaded_map)
	load_world_from_file(loaded_map)


func load_world_from_file(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Could not open file")
		return
	
	var text = file.get_as_text()
	var result = JSON.parse_string(text)
	if result == null:
		push_error("invalid Json")
		return
	
	graph = RavenGraph.new(false)
	grid_world = []
	
	var map_rows = result["rows"]
	var map_columns = result["columns"]
	var map_res = result["resolution"]
	var nodes = result["nodes"]
	
	grid_world.resize(map_rows)
	for i in range(map_rows):
		grid_world[i] = []
		grid_world[i].resize(map_columns)
	
	for node in nodes:
		if node["row"] == 0 or node["row"] == map_rows-1 or node["column"]== 0 or node["column"]==map_columns-1:
			var graph_node = graph.add_vertex(node["type"], Vector2(node["position"]["x"], node["position"]["y"]), true)
			grid_world[node["row"]][node["column"]] = graph_node
		else:
			var graph_node = graph.add_vertex(node["type"], Vector2(node["position"]["x"], node["position"]["y"]), false)
			grid_world[node["row"]][node["column"]] = graph_node
	initialise_grid_container(map_rows, map_columns, map_res, grid_world)
	print("completed")
	
