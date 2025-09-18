class_name GoalWander
extends "res://ProgrammingGameAIByExample/Raven/Goals/Goal.gd"


func activate() -> void:
	status = Status.ACTIVE
	
	# Activate wandering
	owner_agent.steering_controller.set_behaviour("wander", true, 0.9) 


func process() -> Status:
	activate_if_inactive()
	return status


func terminate() -> void:
	owner_agent.steering_controller.set_behaviour("wander", false, 1.0) 
