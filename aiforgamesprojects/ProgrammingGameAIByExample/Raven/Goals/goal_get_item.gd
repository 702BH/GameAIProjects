class_name GoalGetItem
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"



static var goal_to_item = {
	RavenNodeItem.ItemSubType.SHOTGUN : Type.GOAL_GET_SHOTGUN,
	RavenNodeItem.ItemSubType.ROCKET_LAUNCHER : Type.GOAL_GET_ROCKET_LAUNCHER,
	RavenNodeItem.ItemSubType.RAIL_GUN : Type.GOAL_GET_RAILGUN,
	RavenNodeItem.ItemSubType.HEALTH : Type.GOAL_GET_HEALTH
}

var item_type : RavenNodeItem.ItemSubType

func _init(_agent: RavenAgent, _item_type: RavenNodeItem.ItemSubType) -> void:
	super(_agent)
	goal_type = goal_to_item.get(_item_type)
	item_type = _item_type


func activate() -> void:
	status = Status.ACTIVE
	var path  = owner_agent.path_planner.get_path_to_item(owner_agent.position, item_type)
	if !path.is_empty():
		add_subgoal(GoalFollowPath.new(owner_agent, path))
	else:
		print("has failed")
		status = Status.FAILED
	#print("HEALTH GOAL ACTIVATED")

func process() -> Status:
	activate_if_inactive()
	status = process_subgoals()
	
	
	return status


func terminate() -> void:
	remove_all_subgoals()
