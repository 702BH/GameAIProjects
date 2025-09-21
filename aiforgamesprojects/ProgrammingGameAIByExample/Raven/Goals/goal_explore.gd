class_name GoalExplore
extends "res://ProgrammingGameAIByExample/Raven/Goals/GoalComposite.gd"

var current_destination : Vector2
var destination_is_set : bool
var rng := RandomNumberGenerator.new()

func _init(_agent: RavenAgent) -> void:
	super(_agent)
	goal_type = Type.GOAL_EXPLORE
	destination_is_set = false
	rng.randomize()


func activate() -> void:
	status = Status.ACTIVE
	remove_all_subgoals()
	
	if !destination_is_set:
		current_destination = World.get_random_position()
		destination_is_set = true
	
	add_subgoal(GoalMoveToPosition.new(owner_agent, current_destination))

func process() -> Status:
	activate_if_inactive()
	
	status = process_subgoals()
	return status
