extends Node2D

var flock : Array[Sheep] = []
var sheep_prefab := preload("res://ProgrammingGameAIByExample/SheepScene/sheep_scene.tscn")

@onready var sheep_container : Node2D = $SheepContainer
@export var flock_size := 25


var resolution := 30.0
var rows
var columns
var grid = []


func _process(delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	var window_size  = get_viewport_rect().size
	rows = int(window_size.y / resolution)
	columns = int(window_size.x / resolution)
	
	grid.resize(rows)
	for i in range(rows):
		grid[i] = []
		for j in range(columns):
			if randf() > 0.75:
				grid[i].append(randf_range(0.5,1.0))
			else:
				grid[i].append(0.0)
	
	for i in range(flock_size):
		var sheep: Sheep = sheep_prefab.instantiate()
		sheep.position = Vector2(randf_range(50, 100), randf_range(50, 100))
		flock.append(sheep)
		sheep_container.add_child(sheep)
	for sheep : Sheep in flock:
		sheep.flock = flock
		sheep.world = grid
		sheep.resolution = resolution
		sheep.rows = rows
		sheep.cols = columns

func _draw() -> void:
	for row in range(rows):
		for col in range(columns):
			var value = grid[row][col]
			var color = Color(0,value,0)
			draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), color)
