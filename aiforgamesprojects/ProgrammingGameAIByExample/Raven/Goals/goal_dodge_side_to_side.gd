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
		#strafe right
		strafe_target = owner_agent.can_step_right()
		if strafe_target != Vector2.ZERO:
			#print("Agent position ", owner_agent.position)
			#print("Agent velocity normalised" , owner_agent.velocity.normalized())
			#print("Strafing right")
			#print(strafe_target)
			owner_agent.steering_controller.set_target_world(strafe_target)
		else:
			clockwise = !clockwise
			status = Status.INACTIVE
	else:
		strafe_target = owner_agent.can_step_left()
		if strafe_target != Vector2.ZERO:
			#print("Agent position ", owner_agent.position)
			#print("Agent velocity normalised", owner_agent.velocity.normalized())
			#print("Strafing left")
			#print(strafe_target)
			owner_agent.steering_controller.set_target_world(strafe_target)
		else:
			clockwise = !clockwise
			status = Status.INACTIVE


func process() -> Status:
	activate_if_inactive()
	
	# if target out of view terminate
	if !owner_agent.targeting_system.is_target_within_FOV():
		status = Status.COMPLETED
	
	# else if the target reached set status to inactive
	if owner_agent.is_at_position(strafe_target):
		status = Status.INACTIVE
	
	return status

func terminate() -> void:
	owner_agent.steering_controller.set_behaviour("seek", false, 1.0)
	#owner_agent.steering_controller.set_behaviour("obstacle_avoid", false, 1.5)
