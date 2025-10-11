class_name GetHealthGoalEvaluator
extends "res://ProgrammingGameAIByExample/Raven/Goals/goal_evaluator.gd"

var item_sub_type: RavenNodeItem.ItemSubType


func _init( sub_type: RavenNodeItem.ItemSubType) -> void:
	goal_type = GoalType.GET_HEALTH
	item_sub_type = sub_type
	print("HEALTH ADDED: ",item_sub_type)


func calculate_desirability(agent: RavenAgent) -> float:
	var distance:float = RavenFeature.distance_to_item(agent, item_sub_type)
	#return desriability
	if distance == 1:
		return 0.0
	else:
		var tweaker:float = 0.2
		var health : float = RavenFeature.health(agent)
		var desirability = tweaker * (1-health / distance)
		desirability = clamp(desirability, 0, 1)
		return desirability

func set_goal(agent: RavenAgent) -> void:
	print("SET HEALTH GOAL")
	agent.brain.add_goal_get_item(item_sub_type)
