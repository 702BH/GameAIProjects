extends ReferenceRect


var resolution := 30.0
var rows :=0
var columns := 0
var grid_world = []
var grid_size := Vector2.ZERO

var mouse_in := false

func _process(delta: float) -> void:
	queue_redraw()
	

func _on_resized() -> void:
	grid_size = size
	print(grid_size)
	rows = int(grid_size.y / resolution)
	columns = int(grid_size.x / resolution)
	print(rows)
	print(columns)
	queue_redraw()

func _draw() -> void:
	for row in range(rows):
		for col in range(columns):
			var color = Color(1,1,1)
			draw_rect(Rect2(col * resolution, row * resolution, resolution, resolution), color)
	
	if mouse_in:
		var mouse_position:= get_local_mouse_position()
		var mouse_grid = position_to_grid(mouse_position)
		var color = Color(1,0,0)
		draw_rect(Rect2(mouse_grid.x * resolution, mouse_grid.y * resolution, resolution, resolution), color)
		print(mouse_grid)
	
	
	# draw rows?
	for i in range(rows + 1):
		var y = i * resolution
		draw_line(Vector2(0, y), Vector2(grid_size.x, y), Color.RED, 1.0)
	
	for c in range(columns + 1):
		var x = c * resolution
		draw_line(Vector2(x, 0), Vector2(x, grid_size.y), Color.RED, 1.0)



func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, columns - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)


func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false
