class_name SteeringObstacleAvoidance
extends SteeringState



func _enter_tree() -> void:
	print("Avoiding")


func _physics_process(delta: float) -> void:
	var multiplier = 1.0 + (vehicle.detection_box_length)
