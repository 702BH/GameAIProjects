class_name flockingVehicle
extends Node2D


var acceleration := Vector2.ZERO
var velocity := Vector2(randf_range(-1, 1), randf_range(-1,1)).normalized() * 10.0
var tagged := false

@export var radius := 15.0
@export var max_speed := 100.0
@export var max_force := 10.0
@export var max_turn_rate := 1.0
@export var color : Color
@export var separation_weight := 1.5
@export var allignment_weight := 1.0
@export var cohesion_weight := 1.0
@export var neighbor_radius := 50.0

@onready var flock : Array[flockingVehicle] = []



func _physics_process(delta: float) -> void:
	flock_sim()
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta
	acceleration = Vector2.ZERO
	wrap_around()
	rotateVehicle(delta)

func _process(_delta):
	queue_redraw()

func apply_force(force: Vector2):
	acceleration += force

func _draw() -> void:
	var points = PackedVector2Array([Vector2(-radius, -radius), Vector2(radius, 0), Vector2(-radius, radius)])
	var colors = PackedColorArray([color.to_rgba64(), color.to_rgba64(), color.to_rgba64()])
	draw_primitive(points, colors, [])



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


func flock_sim() -> void:
	var sep = seperate()
	var ali = allignment()
	var coh = cohesion()
	sep = sep * separation_weight
	ali = ali * allignment_weight
	coh = coh * cohesion_weight
	apply_force(sep)
	apply_force(ali)
	apply_force(coh)


func tag_neighbors() -> void:
	for vehicle : flockingVehicle in flock:
		vehicle.tagged = false
	for vehicle : flockingVehicle in flock:
		if vehicle == self:
			continue
		var to = position - vehicle.position
		var range = neighbor_radius + vehicle.radius
		if to.length_squared() < range * range:
			vehicle.tagged = true


func seek(target : Vector2) -> Vector2:
	var desired_velocity : Vector2 = (target - position).normalized() * max_speed
	var steer = (desired_velocity - velocity).limit_length(max_force)
	return steer


func seperate() -> Vector2:
	var steering_force := Vector2.ZERO
	var desired_sep = 25
	var count = 0
	
	for vehicle : flockingVehicle in flock:
		if vehicle == self:
			continue
		var d = position.distance_to(vehicle.position)
		if d > 0 and d < desired_sep:
			var to_vehicle = position - vehicle.position
			to_vehicle = to_vehicle.normalized()
			to_vehicle = to_vehicle / d
			steering_force += to_vehicle
			count += 1
	if count > 0:
		steering_force = steering_force / count
	if steering_force.length() > 0:
		steering_force = steering_force.normalized()
		steering_force = steering_force * max_speed
		steering_force = steering_force - velocity
		steering_force = steering_force.limit_length(max_force)
	return steering_force

func allignment() -> Vector2:
	var average_heading := Vector2.ZERO
	var neighbor_disance = 50
	var neighbor_count := 0
	
	for vehicle : flockingVehicle in flock:
		if vehicle == self:
			continue
		var d = position.distance_to(vehicle.position)
		if d > 0 and d < neighbor_disance:
			average_heading += vehicle.velocity
			neighbor_count += 1
	
	if neighbor_count > 0:
		average_heading = average_heading / neighbor_count
		average_heading = average_heading.normalized()
		average_heading = average_heading * max_speed
		var steer = average_heading - velocity
		steer = steer.limit_length(max_force)
		return steer
	else:
		return Vector2.ZERO


func cohesion() -> Vector2:
	var center_of_mass := Vector2.ZERO
	var neighbor_disance = 50
	var steering_force := Vector2.ZERO
	var neighbor_count := 0
	
	for vehicle : flockingVehicle in flock:
		if vehicle == self:
			continue
		var d = position.distance_to(vehicle.position)
		if d > 0 and d < neighbor_disance:
			center_of_mass += vehicle.position
			neighbor_count +=1
	
	if neighbor_count > 0:
		center_of_mass = center_of_mass / neighbor_count
		return seek(center_of_mass)
	else:
		return Vector2.ZERO
