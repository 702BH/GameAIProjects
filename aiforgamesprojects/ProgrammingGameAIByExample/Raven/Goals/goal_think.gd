class_name GoalThink
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	goal_type = Type.GOAL_THINK


func not_present(_type: Type) -> bool:
	if !subgoals.is_empty():
		return subgoals.front().goal_type != _type
	
	return true


func add_goal_explore() -> void:
	if not_present(Type.GOAL_EXPLORE):
		remove_all_subgoals()
		add_subgoal(GoalExplore.new(owner_agent))
