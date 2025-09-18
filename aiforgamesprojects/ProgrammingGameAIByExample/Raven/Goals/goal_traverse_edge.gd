class_name  GoalTraverseEdge
extends "res://ProgrammingGameAIByExample/Raven/Goals/Goal.gd"


var edge : PathEdge
var last_edge :bool
var time_expected : float
var start_time : float

func _init(agent: RavenAgent, _edge: PathEdge, _last_edge:bool, _time_expected:float, _start_time:float) -> void:
	super(agent)
	edge = _edge
	last_edge = _last_edge


func activate() -> void:
	status = Status.ACTIVE
	
	start_time = Time.get_ticks_msec()
	time_expected = (edge.cost / owner_agent.max_speed + 2.0) * 1000.0
	
	# Set the steering target
	owner_agent.steering_controller.set_target(edge.destination)
	
	if last_edge:
		owner_agent.steering_controller.set_behaviour("arrive", true, 1.0)
	else:
		owner_agent.steering_controller.set_behaviour("seek", true, 1.0) 


func process() -> Status:
	activate_if_inactive()
	
	if is_stuck():
		status = Status.FAILED
	else:
		if owner_agent.is_at_position(edge.destination):
			status = Status.COMPLETED
	
	return status

func terminate() -> void:
	# turn off steering behaviours
	owner_agent.steering_controller.set_behaviour("arrive", false, 1.0)
	owner_agent.steering_controller.set_behaviour("seek", false, 1.0) 

func is_stuck() -> bool:
	var time_taken = Time.get_ticks_msec() - start_time
	if time_taken > time_expected:
		return true
	return false
