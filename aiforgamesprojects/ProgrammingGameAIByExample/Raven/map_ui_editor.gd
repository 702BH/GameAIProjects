extends Control

@onready var grid_container := $Container/GridContainer

var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var graph: RavenGraph


func _ready() -> void:
	graph = RavenGraph.new(false)
	generate_grid()
	initialise_grid_container()
	print(grid_world[2][5])

func generate_grid() -> void:
	rows = int(grid_container.size.y / resolution)
	columns = int(grid_container.size.x / resolution)
	grid_world.resize(rows)
	for i in range(rows):
		grid_world[i] = []
		for j in range(columns):
			if i == 0 or i == rows-1 or j== 0 or j==columns-1:
				graph.add_vertex(RavenNode.NodeType.WALL, Vector2(j * resolution + resolution / 2, i * resolution + resolution / 2))
				grid_world[i].append(graph.nodes[i * columns + j])
			else:
				graph.add_vertex(RavenNode.NodeType.TRAVERSAL, Vector2(j * resolution + resolution / 2, i * resolution + resolution / 2))
				grid_world[i].append(graph.nodes[i * columns + j])


func initialise_grid_container() -> void:
	grid_container.rows = rows
	grid_container.columns = columns
	grid_container.resolution = resolution
	grid_container.grid_world = grid_world
	grid_container.queue_redraw()
