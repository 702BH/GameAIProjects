class_name GoalFollowPath
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"


var path : Array[PathEdge]

func _init(_agent: RavenAgent, _path: Array[PathEdge]) -> void:
	super(_agent)
	path = _path
	goal_type = Type.GOAL_FOLLOW_PATH


func activate() -> void:
	status = Status.ACTIVE
	
	# reference to the next edge
	var edge: PathEdge = path.front()
	
	path.pop_front()
	
	add_subgoal(GoalTraverseEdge.new(owner_agent, edge, path.is_empty()))


func process() -> Status:
	activate_if_inactive()
	
	status = process_subgoals()
	
	if status == Status.COMPLETED and !path.is_empty():
		activate()
	
	return status

func terminate() -> void:
	remove_all_subgoals()
