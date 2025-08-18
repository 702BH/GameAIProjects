extends ReferenceRect


signal source_placed
signal target_placed
signal walls_placed


var placing_source := false
var placing_target := false
var placing_walls := false

var resolution := 30.0
var rows :=0
var columns := 0
var grid_world = []
var grid_size := Vector2.ZERO

var mouse_in := false

var source_location := Vector2.ZERO
var target_location := Vector2.ZERO

var walls: Array[Vector2] = []
var paths: Array[Vector2] = []

var graph: SparseGraph


func _process(delta: float) -> void:
	queue_redraw()
	if !mouse_in:
		return
	if placing_walls and Input.is_action_pressed("place"):
		var wall_location = position_to_grid(get_local_mouse_position())
		wall_location = Vector2(wall_location.y, wall_location.x)
		if !walls.has(wall_location):
			walls.append(wall_location)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		if !mouse_in:
			return
		
		if placing_source:
			source_location = position_to_grid(get_local_mouse_position())
			placing_source =false
			source_placed.emit()
		if placing_target:
			target_location = position_to_grid(get_local_mouse_position())
			placing_target = false
			target_placed.emit()




func _on_resized() -> void:
	print("resised")
	grid_size = size
	rows = int(grid_size.y / resolution)
	columns = int(grid_size.x / resolution)
	queue_redraw()

func _draw() -> void:
	for row in range(rows):
		for col in range(columns):
			var color = Color(1,1,1)
			draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), color)
	
	# draw rows?
	for i in range(rows + 1):
		var y = i * resolution
		draw_line(Vector2(0, y), Vector2(grid_size.x, y), Color.RED, 1.0)
	
	for c in range(columns + 1):
		var x = c * resolution
		draw_line(Vector2(x, 0), Vector2(x, grid_size.y), Color.RED, 1.0)
	
	
	if source_location != Vector2.ZERO:
		draw_rect(Rect2(source_location.x * resolution, source_location.y * resolution, resolution, resolution), Color8(228,116,96))
	
	if target_location != Vector2.ZERO:
		draw_rect(Rect2(target_location.x * resolution, target_location.y * resolution, resolution, resolution), Color8(153,0,0))
	
	for wall in walls:
		var draw_x = wall.y * resolution
		var draw_y = wall.x * resolution
		draw_rect(Rect2(draw_x, draw_y, resolution, resolution), Color.BLACK)
	
	if mouse_in:
		var mouse_position:= get_local_mouse_position()
		var mouse_grid = position_to_grid(mouse_position)
		if placing_source:
			var color = Color8(228,116,96)
			draw_rect(Rect2(mouse_grid.x * resolution, mouse_grid.y * resolution, resolution, resolution), color)
		elif placing_target:
			var color = Color8(153,0,0)
			draw_rect(Rect2(mouse_grid.x * resolution, mouse_grid.y * resolution, resolution, resolution), color)
		elif placing_walls:
			var color = Color.BLACK
			draw_rect(Rect2(mouse_grid.x * resolution, mouse_grid.y * resolution, resolution, resolution), color)
		else:
			var color = Color(1,0,0)
			draw_rect(Rect2(mouse_grid.x * resolution, mouse_grid.y * resolution, resolution, resolution), color)
	
	




func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)


func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false
