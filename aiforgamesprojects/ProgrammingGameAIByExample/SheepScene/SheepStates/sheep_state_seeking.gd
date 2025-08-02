class_name  SheepStateSeeking
extends SheepState

func _enter_tree() -> void:
	steering_controller.behaviors["evade"]["active"] = false
	steering_controller.behaviors["wander"]["active"] = true
	steering_controller.behaviors["wander"]["weight"] = 0.9
	steering_controller.behaviors["cohesion"]["active"] = true
	steering_controller.behaviors["cohesion"]["weight"] = 0.3
	steering_controller.behaviors["seperation"]["active"] = true
	steering_controller.behaviors["seperation"]["weight"] = 0.8
	steering_controller.behaviors["alignment"]["active"] = true
	steering_controller.behaviors["alignment"]["weight"] = 0.7

func _physics_process(delta: float) -> void:
	find_food()

func find_food() -> void:
	var grid_pos = sheep.position_to_grid(sheep.position)
	var row = grid_pos.y
	var col = grid_pos.x
	if sheep.world[row][col] >= 0.5:
		transition_state(Sheep.State.EATING)
