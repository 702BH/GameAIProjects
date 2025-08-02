class_name SheepStateSleeping
extends SheepState


func _enter_tree() -> void:
	steering_controller.behaviors["evade"]["active"] = false
	steering_controller.behaviors["wander"]["active"] = false
	steering_controller.behaviors["cohesion"]["active"] = false
	steering_controller.behaviors["seperation"]["active"] = false
	steering_controller.behaviors["alignment"]["active"] = false
	sheep.velocity = Vector2.ZERO
