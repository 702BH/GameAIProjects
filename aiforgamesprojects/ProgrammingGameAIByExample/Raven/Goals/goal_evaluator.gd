class_name GoalEvaluator
extends RefCounted


enum GoalType {EXPLORE, ATTACK_TARGET, GET_WEAPON, GET_HEALTH}
var goal_type: GoalType

func calculate_desirability(agent: RavenAgent) -> float:
	return 0


func set_goal(agent: RavenAgent) -> void:
	pass
