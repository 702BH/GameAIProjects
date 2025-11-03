extends Control

var point1 : Vector2 = Vector2(0,0)
@export_range(1, 1000) var segments : int = 64
@export var width : int = 6
@export var color : Color = Color.GREEN
@export var antialiasing : bool = false

var _point2 : Vector2
var radius := 20.0
var angle := 0.0
var speed := 2.0

var loading := false

func _ready() -> void:
	#point1 = Vector2(size.x/2, size.y/2)
	_point2 = Vector2(0, 0)


#func _process(delta: float) -> void:
	#if loading:
		#angle += speed * delta
		#if angle > TAU:
			#angle = 0.0
		#queue_redraw()

func _draw():
	if loading:
		draw_set_transform(Vector2(size.x/2, size.y/2))
		var _p2 = point1 + Vector2.from_angle(angle) * radius
		draw_arc(point1, radius, 0, angle, segments, color, width)
	## Average points to get center.
	#var center : Vector2 = Vector2((_point2.x + point1.x) / 2,
								   #(_point2.y + point1.y) / 2)
	## Calculate the rest of the arc parameters.
	#var radius : float = point1.distance_to(_point2) / 2
	#var start_angle : float = (_point2 - point1).angle()
	#var end_angle : float = (point1 - _point2).angle()
	#if end_angle < 0:  # end_angle is likely negative, normalize it.
		#end_angle += TAU
#
	## Finally, draw the arc.
	#draw_arc(center, radius, start_angle, end_angle, segments, color,
			 #width, antialiasing)
