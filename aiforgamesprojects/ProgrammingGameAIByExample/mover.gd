class_name Mover
extends Node2D


var acceleration := Vector2.ZERO
var velocity := Vector2(0.0, 1.0)
var radius := 15.0
var min_detection_box_length := 50.0
var detection_box_length := 50.0



@export var mass := 1.0
@export var max_speed := 1.0
@export var max_force := 1.0
@export var max_turn_rate := 1.0
@export var color : Color
@export var flee_speed := 1.0

var pointsDetector : PackedVector2Array = []


func _process(_delta):
	queue_redraw()

func apply_force(force: Vector2):
	acceleration += force / mass

func _draw() -> void:
	var points = PackedVector2Array([Vector2(-radius, -radius), Vector2(radius, 0), Vector2(-radius, radius)])
	var colors = PackedColorArray([color.to_rgba64(), color.to_rgba64(), color.to_rgba64()])
	draw_primitive(points, colors, [])
	pointsDetector = PackedVector2Array([
		Vector2(-radius, -radius),
		Vector2(detection_box_length, -radius),
		Vector2(detection_box_length, radius),
		Vector2(-radius, radius)
	])
	var colorsDetector = PackedColorArray([Color.from_rgba8(255, 0,0,125), Color.from_rgba8(255, 0,0,125), Color.from_rgba8(255, 0,0,125)])
	draw_primitive(pointsDetector, colorsDetector, [])


func wrap_around() -> void:
	var window_size := get_window().size
	var width = window_size.x
	var height = window_size.y
	
	if position.x > width:
		position.x = 0.0
	elif position.x < 0.0:
		position.x = width
	if position.y > height:
		position.y = 0.0
	elif position.y < 0.0:
		position.y = height


func rotateVehicle(delta) -> void:
	var target := velocity.angle()
	rotation = rotate_toward(rotation, target, max_turn_rate * delta)
	#look_at(target)
	#rotation = velocity.angle()
	
