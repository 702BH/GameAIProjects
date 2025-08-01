class_name CrossHair
extends Target

var is_placing := false



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_placing = !is_placing


func _process(delta: float) -> void:
	queue_redraw()
	if is_placing:
		global_position = get_global_mouse_position()


func _draw() -> void:
	draw_line(Vector2(0, -10), Vector2(0, 10), "red", 2.0)
	draw_line(Vector2(-10, 0), Vector2(10, 0), "red", 2.0)
