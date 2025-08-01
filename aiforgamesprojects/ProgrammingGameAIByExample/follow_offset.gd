extends Node2D



@onready var vehicle_prefab := preload("res://ProgrammingGameAIByExample/vehicle.tscn")
@onready var crosshair : CrossHair = $CrossHair
@onready var vehicle_container : Node2D = $VehicleContainer

func _ready() -> void:
	crosshair.is_placing = true
	spawn_vehicles()


func spawn_vehicles():
	var leader : Vehicle = vehicle_prefab.instantiate()
	leader.target = crosshair
	leader.radius = 15.0
	leader.is_debugging = false
	leader.position = Vector2(get_window().size.x / 2, get_window().size.y / 2)
	leader.switch_state(Vehicle.State.ARRIVE)
	vehicle_container.add_child(leader)
	
	for i in range(2):
		var follower : Vehicle = vehicle_prefab.instantiate()
		follower.leader = leader
		follower.radius = 7.0
		follower.is_debugging = false
		follower.position = Vector2(get_window().size.x / 2 + randf_range(-20, 20), get_window().size.y / 2 + randf_range(-20, 20))
		follower.switch_state(Vehicle.State.PURSUE_OFFSET)
		follower.name = "Follower : " + str(i)
		vehicle_container.add_child(follower)
