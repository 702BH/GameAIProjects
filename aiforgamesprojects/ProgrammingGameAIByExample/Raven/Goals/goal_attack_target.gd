class_name GoalAttackTarget
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"

var last_seen_pos : Vector2

func _init(_agent: RavenAgent) -> void:
	super(_agent)
	goal_type = Type.GOAL_ATTACK_TARGET
	#print("Agent: ", _agent, " is attacking")

func activate() -> void:
	
	
	status = Status.ACTIVE
	remove_all_subgoals()
	
	if !owner_agent.targeting_system.current_target:
		print("NO TARGET")
		status = Status.COMPLETED
		return
	
	#last_seen_pos = owner_agent.targeting_system.current_target.position
	add_subgoal(GoalMoveToPosition.new(owner_agent, owner_agent.targeting_system.current_target.position))

func process() -> Status:
	
	# Too expensive
	# Have to find alternative way.
	#if owner_agent.targeting_system.current_target:
		#if last_seen_pos:
			#if last_seen_pos.distance_squared_to(owner_agent.targeting_system.current_target.position) > 200:
				#print("Target moved")
				#activate()
	
	activate_if_inactive()
	status = process_subgoals()
	
	reactivate_if_failed()
	
	return status


func terminate() -> void:
	status = Status.COMPLETED
