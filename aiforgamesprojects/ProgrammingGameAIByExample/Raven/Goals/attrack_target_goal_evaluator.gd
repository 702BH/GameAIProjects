class_name AttackTargetGoalEvaluator
extends "res://ProgrammingGameAIByExample/Raven/Goals/goal_evaluator.gd"


func _init() -> void:
	goal_type = GoalType.ATTACK_TARGET

func calculate_desirability(agent: RavenAgent) -> float:
	var desirability:float = 0.0
	
	# Only do the calculation if there is a target present
	if agent.targeting_system.current_target:
		var tweaker : float = 1.0
		
		desirability = tweaker * RavenFeature.health(agent) * RavenFeature.total_weapon_strength(agent)
	
	
	return desirability


func set_goal(agent: RavenAgent) -> void:
	agent.brain.add_goal_attack_target()
