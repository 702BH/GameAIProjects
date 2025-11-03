class_name ExploreGoalEvaluator
extends "res://ProgrammingGameAIByExample/Raven/Goals/goal_evaluator.gd"

var desriability := 0.05

func _init() -> void:
	goal_type = GoalType.EXPLORE


func calculate_desirability(agent: RavenAgent) -> float:
	return desriability

func set_goal(agent: RavenAgent) -> void:
	agent.brain.add_goal_explore()
	#agent.brain.add_goal_wander()
