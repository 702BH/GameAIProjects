extends Node2D
#

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var mouse_position:= get_global_mouse_position()
	var mouse_grid = World.position_to_grid(mouse_position)
	var color = Color.CRIMSON
	color.a = 0.5
	draw_rect(Rect2(mouse_grid.x * World.resolution, mouse_grid.y * World.resolution, World.resolution, World.resolution), color)
	
	for key in World.cell_buckets_static:
			var walls = World.cell_buckets_static[key]
			for wall in walls:
				if !wall.is_border:
					var wall_segments = wall.wall_segments
					for j in range(wall_segments.size()):
						draw_line(wall_segments[j][0], wall_segments[j][0] + wall.wall_normals[j] * 5.0, Color.BLUE)
