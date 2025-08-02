extends Node2D

var flock : Array[Sheep] = []
var sheep_prefab := preload("res://ProgrammingGameAIByExample/SheepScene/sheep_scene.tscn")

@onready var sheep_container : Node2D = $SheepContainer
@export var flock_size := 80


var resolution := 30.0
var rows
var columns
var grid = []

var bin_res := 80.0
var bin_cols
var bin_rows
var bin_grid = []


func _physics_process(delta: float) -> void:
	for i in range(bin_rows):
		for j in range(bin_cols):
			bin_grid[i][j].clear()
	
	for sheep : Sheep in flock:
		var col = clamp(int(sheep.position.x / bin_res), 0, bin_cols - 1)
		var row = clamp(int(sheep.position.y / bin_res) , 0 , bin_rows - 1)
		bin_grid[row][col].append(sheep)
	
	for sheep : Sheep in flock:
		sheep.bin_grid = bin_grid

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
	
	
	bin_cols = int(window_size.x / bin_res)
	bin_rows = int(window_size.y / bin_res)
	
	bin_grid.resize(bin_rows)
	for i in range(bin_rows):
		bin_grid[i] = []
		bin_grid[i].resize(bin_cols)
		for j in range(bin_cols):
			bin_grid[i][j] = [] as Array[Sheep]
	
	
	for i in range(flock_size):
		var sheep: Sheep = sheep_prefab.instantiate()
		sheep.position = Vector2(randf_range(10, window_size.x), randf_range(10, window_size.y))
		flock.append(sheep)
		sheep_container.add_child(sheep)
	for sheep : Sheep in flock:
		sheep.flock = flock
		sheep.world = grid
		sheep.resolution = resolution
		sheep.rows = rows
		sheep.cols = columns
		sheep.bin_grid = bin_grid
		sheep.bin_cols = bin_cols
		sheep.bin_rows = bin_rows
		sheep.bin_res = bin_res

func _draw() -> void:
	for row in range(rows):
		for col in range(columns):
			var value = grid[row][col]
			var color = Color(0,value,0)
			draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), color)
	
	var window_size  = get_viewport_rect().size
	for col in range(bin_cols + 1):
		var x = col * bin_res
		draw_line(Vector2(x, 0), Vector2(x, window_size.y), Color(1, 1, 1, 0.3), 1.0)
	for row in range(bin_rows + 1):
		var y = row * bin_res
		draw_line(Vector2(0, y), Vector2(window_size.x, y), Color(1, 1, 1, 0.3), 1.0)
