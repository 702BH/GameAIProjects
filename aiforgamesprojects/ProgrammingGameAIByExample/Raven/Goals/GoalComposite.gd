class_name GoalComposite
extends "res://ProgrammingGameAIByExample/Raven/Goals/Goal.gd"


var subgoals: Array[Goal] = []

func add_subgoal(g: Goal) -> void:
	subgoals.push_front(g)

func process_subgoals() -> Status:
	# Remove completed/failed from front
	while !subgoals.is_empty() and (subgoals.front().is_completed() or subgoals.front().has_failed()):
		subgoals.front().terminate()
		subgoals.pop_front()
	
	if not subgoals.is_empty():
		var status_of_subgoal = subgoals.front().process()
		
		if status_of_subgoal == Status.COMPLETED and subgoals.size() > 1:
			return Status.ACTIVE
		return status_of_subgoal
	else:
		return Status.COMPLETED


func remove_all_subgoals() -> void:
	for subgoal:Goal in subgoals:
		subgoal.terminate()
	
	subgoals.clear()


func to_dict() -> GoalDataDebug:
	
	var data:= GoalDataDebug.new(_get_name(), _get_status(), [], {})
	
	
	for sub in subgoals:
		data.children.append(sub.to_dict())
	
	return data
