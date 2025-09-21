class_name GoalMoveToPosition
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"

var destination: Vector2

func _init(_agent: RavenAgent, _pos) -> void:
	super(_agent)
	destination = _pos
	goal_type = Type.GOAL_MOVE_TO_POSITION


func activate() -> void:
	status = Status.ACTIVE
	
	# Make sure the subgoal is clear
	remove_all_subgoals()
	
	# request a new path
	var path  = owner_agent.path_planner.get_path_to_target(destination, owner_agent.position)
	print("Path for Agent: ", owner_agent)
	print("Path: ", path)
	if !path.is_empty():
		add_subgoal(GoalFollowPath.new(owner_agent, path))
	else:
		status = Status.FAILED

func process() -> Status:
	activate_if_inactive()
	
	status = process_subgoals()
	
	reactivate_if_failed()
	
	return status
