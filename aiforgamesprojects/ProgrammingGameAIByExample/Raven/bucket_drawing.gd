class_name BucketDrawing
extends Node2D

var key
var last_key : Vector2i
var current_cell_space: Array = []

func _process(delta: float) -> void:
	var mouse_pos = World.position_to_grid(get_global_mouse_position())
	var cell_x = int(mouse_pos.x/World.cell_size)
	var cell_y = int(mouse_pos.y/World.cell_size)
	key = Vector2i(cell_x, cell_y)
	if key != last_key:
		current_cell_space = World.cell_buckets_static.get(key, [])
		queue_redraw()

func _draw() -> void:
	for node: RavenNode in current_cell_space:
		draw_rect(Rect2(node.node_pos.x * World.resolution, node.node_pos.y * World.resolution, World.resolution, World.resolution), Color(1.2, 1, 0, 0.4))
