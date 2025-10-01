class_name GoalThink
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"


var evaluators : Array[GoalEvaluator] = []



func _init(_agent: RavenAgent) -> void:
	super(_agent)
	goal_type = Type.GOAL_THINK
	
	# create the evalutor objects
	evaluators.push_back(ExploreGoalEvaluator.new())
	evaluators.push_back(AttackTargetGoalEvaluator.new())


func activate() -> void:
	arbitrate()
	status = Status.ACTIVE

func process() -> Status:
	activate_if_inactive()
	
	var sub_goal_status: Status = process_subgoals()
	if sub_goal_status == Status.COMPLETED or sub_goal_status == Status.FAILED:
		status = Status.INACTIVE
	
	return status


func arbitrate() -> void:
	var best := 0.0
	
	var most_desirable: GoalEvaluator
	
	for eval:GoalEvaluator in evaluators:
		var desire :float = eval.calculate_desirability(owner_agent)
		if desire >= best:
			best = desire
			most_desirable = eval
	
	#print("most desirable: ", most_desirable.goal_type)
	most_desirable.set_goal(owner_agent)
			#var data = PlayerStateData.build().set_shot_power(shot_power).set_shot_direction(shot_direction)
	
	if owner_agent.debug_regulator.is_ready():
		var data = BrainData.build().set_agent(owner_agent).set_system(DebugData.Systems.BRAIN).set_step(BrainData.Steps.ARBITRATION)
		data.add_message("Most Desirable Goal: " + str( GoalEvaluator.GoalType.keys()[most_desirable.goal_type]))
		RavenServiceBus.debug_event.emit(data)


func not_present(_type: Type) -> bool:
	if !subgoals.is_empty():
		return subgoals.front().goal_type != _type
	
	return true


func add_goal_explore() -> void:
	if not_present(Type.GOAL_EXPLORE):
		remove_all_subgoals()
		add_subgoal(GoalExplore.new(owner_agent))
		#print("SHOULD EXPLORE PLEASE")
		RavenServiceBus.agent_goal_changed.emit(owner_agent, GoalEvaluator.GoalType.EXPLORE)


func add_goal_attack_target() -> void:
	if not_present(Type.GOAL_ATTACK_TARGET):
		remove_all_subgoals()
		add_subgoal(GoalAttackTarget.new(owner_agent))
		RavenServiceBus.agent_goal_changed.emit(owner_agent, GoalEvaluator.GoalType.ATTACK_TARGET)
