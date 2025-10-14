class_name GoalHuntTarget
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"


var last_point_tried : bool

func _init(_agent: RavenAgent) -> void:
	super(_agent)
	goal_type = Type.GOAL_HUNT_TARGET
	last_point_tried = false


func activate() -> void:
	status = Status.ACTIVE
	
	remove_all_subgoals()
	
	if owner_agent.targeting_system.current_target:
		var last_recorded_position: Vector2 = owner_agent.targeting_system.get_last_recorded_position()
		
		# if reach last position, explore to move to random locations
		if last_recorded_position == Vector2.ZERO or owner_agent.is_at_position(last_recorded_position):
			add_subgoal(GoalExplore.new(owner_agent))
		
		else:
			add_subgoal(GoalMoveToPosition.new(owner_agent, last_recorded_position))
	else:
		status = Status.COMPLETED

func process() -> Status:
	activate_if_inactive()
	
	status = process_subgoals()
	
	# if the target is in view this goal is satisified
	if owner_agent.targeting_system.is_target_within_FOV():
		status = Status.COMPLETED
	return status
	
