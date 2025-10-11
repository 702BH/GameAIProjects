class_name GetWeaponGoalEvaluator
extends "res://ProgrammingGameAIByExample/Raven/Goals/goal_evaluator.gd"

var weapon_type : RavenWeapon.WeaponType
var item_sub_type: RavenNodeItem.ItemSubType


func _init(wt: RavenWeapon.WeaponType, sub_type: RavenNodeItem.ItemSubType) -> void:
	goal_type = GoalType.GET_WEAPON
	weapon_type = wt
	item_sub_type = sub_type


func calculate_desirability(agent: RavenAgent) -> float:
	var distance:float = RavenFeature.distance_to_item(agent, item_sub_type)
	#return desriability
	if distance == 1:
		return 0.0
	else:
		var tweaker:float = 0.15
		var health : float = RavenFeature.health(agent)
		var weapon_strength: float = RavenFeature.individual_weapon_strength(agent, weapon_type)
		var desirability : float = (tweaker * health * (1-weapon_strength)/distance)
		return desirability

func set_goal(agent: RavenAgent) -> void:
	print("SET WEAPON GOAL")
	agent.brain.add_goal_get_item(item_sub_type)
