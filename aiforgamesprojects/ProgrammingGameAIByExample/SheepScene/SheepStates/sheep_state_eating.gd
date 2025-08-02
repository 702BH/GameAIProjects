class_name SheepStateEating
extends SheepState

var eat_amount := 0.3
var hunger_conversion := 1.3 / eat_amount

func _enter_tree() -> void:
	steering_controller.behaviors["evade"]["active"] = false
	steering_controller.behaviors["wander"]["active"] = false
	steering_controller.behaviors["cohesion"]["active"] = true
	steering_controller.behaviors["cohesion"]["weight"] = 0.2
	steering_controller.behaviors["seperation"]["active"] = true
	steering_controller.behaviors["seperation"]["weight"] = 0.5
	steering_controller.behaviors["alignment"]["active"] = false


func _physics_process(delta: float) -> void:
	eat(delta)

func eat(delta):
	var grid_pos = sheep.position_to_grid(sheep.position)
	var row = grid_pos.y
	var col = grid_pos.x
	
	var max_eat = eat_amount * delta
	var available = sheep.world[row][col]
	var actual_eat = min(available, max_eat)
	
	sheep.hunger = clamp(sheep.hunger - actual_eat * hunger_conversion, 0 , sheep.max_hunger)
	
	sheep.world[row][col] -= actual_eat
	if sheep.world[row][col] <= 0.0:
		transition_state(Sheep.State.SEEKING)
