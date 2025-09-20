class_name GoalAttackTarget
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"


func activate() -> void:
	status = Status.ACTIVE
	remove_all_subgoals()
	
	if !owner_agent.targeting_system.current_target:
		status = Status.COMPLETED
		return
	
	add_subgoal(GoalMoveToPosition.new(owner_agent, owner_agent.targeting_system.current_target.position))

func process() -> Status:
	activate_if_inactive()
	status = process_subgoals()
	
	reactivate_if_failed()
	
	return status


func terminate() -> void:
	status = Status.COMPLETED
