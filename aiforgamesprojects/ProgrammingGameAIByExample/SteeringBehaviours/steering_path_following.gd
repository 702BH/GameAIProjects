class_name SteeringPathFollowing
extends SteeringState

const WAYPOINT_SEEK_DISTANCE := 200.0

var current_way_point : Vector2
var new_way_point

func _enter_tree() -> void:
	if !path.points.is_empty():
		current_way_point = path.points[0]


func _physics_process(delta: float) -> void:
	if current_way_point.distance_squared_to(vehicle.position) < WAYPOINT_SEEK_DISTANCE:
		pass
