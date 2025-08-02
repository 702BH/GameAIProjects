extends Node2D


var flock : Array[flockingVehicle] = []
var boid_prefab := preload("res://ProgrammingGameAIByExample/GroupBheaviours/flocking_vehicle.tscn")

@export var flock_size := 50

func _ready() -> void:
	for i in range(flock_size):
		var vehicle: flockingVehicle = boid_prefab.instantiate()
		vehicle.position = Vector2(randf_range(50,100), randf_range(50,100))
		flock.append(vehicle)
		add_child(vehicle)
	for vehicle : flockingVehicle in flock:
		vehicle.flock = flock
