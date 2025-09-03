extends Node2D

@onready var ui := $CanvasLayer/UI
@onready var grid_container := $CanvasLayer/UI/Container/GridContainer


var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var graph: RavenGraph
var loaded_map := ""

var spawn_points := []


func _ready() -> void:
	graph = RavenGraph.new(false)
	generate_grid()
	initialise_ui_container(rows, columns, resolution, grid_world, graph, spawn_points)
	ui.initialise_grid_container(rows, columns, resolution, grid_world, ui)


func initialise_ui_container(rows, columns, resolution, grid_world, graph, spawn_points) -> void:
	ui.rows = rows
	ui.columns = columns
	ui.resolution = resolution
	ui.grid_world = grid_world
	ui.graph = graph
	ui.spawn_points = spawn_points


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
