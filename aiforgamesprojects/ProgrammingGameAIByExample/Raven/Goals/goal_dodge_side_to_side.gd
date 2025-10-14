class_name GoalDodgeSideToSide
extends "res://ProgrammingGameAIByExample/Raven/Goals/Goal.gd"

var strafe_target: Vector2
var clockwise : bool

func _init(_agent: RavenAgent) -> void:
	super(_agent)
	goal_type = Type.GOAL_STRAFE
	clockwise = randi_range(0, 1)

func activate() -> void:
	status = Status.ACTIVE
	
	# set steering behaviours
	owner_agent.steering_controller.set_behaviour("seek", true, 1.0)
	owner_agent.steering_controller.set_behaviour("obstacle_avoid", true, 1.5) 
	
	if clockwise:
		var step_right = owner_agent.can_step_right()
		if step_right != Vector2.ZERO:
			owner_agent.steering_controller.set_target_world(step_right)
	else:
		clockwise = !clockwise
