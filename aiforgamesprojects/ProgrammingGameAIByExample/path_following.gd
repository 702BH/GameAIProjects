extends Node2D


var paths : PathI = PathI.new()

var is_placing_point := false

@onready var vehicle : Vehicle = $Vehicle
@onready var move_toggle :Button = $PathControls/VBoxContainer/HBoxContainer2/Move

var is_moving := false

func _ready() -> void:
	vehicle.path = paths
	vehicle.switch_state(Vehicle.State.WANDER)
	is_moving = move_toggle.button_pressed

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_placing_point:
				is_placing_point = false
				paths.points.append(get_global_mouse_position())


func _process(delta: float) -> void:
	queue_redraw()
	print(paths.is_closed)

func _on_add_point_pressed() -> void:
	is_placing_point = true

func _draw() -> void:
	if is_placing_point:
		draw_circle(get_global_mouse_position(), 20, "red")
	
	for i in paths.points.size():
		draw_circle(paths.points[i], 25, "blue")
		if paths.points.size() > 1 and i < paths.points.size() - 1:
			draw_line(paths.points[i], paths.points[i + 1], "green", 2.0)


func _on_is_closed_toggled(toggled_on: bool) -> void:
	paths.is_closed = !paths.is_closed


func _on_move_toggled(toggled_on: bool) -> void:
	paths.current_index = 0
	is_moving = move_toggle.button_pressed
	if is_moving:
		vehicle.switch_state(Vehicle.State.PATH_FOLLOWING)
	elif !(vehicle.current_state is SteeringWander):
		vehicle.switch_state(Vehicle.State.WANDER)
