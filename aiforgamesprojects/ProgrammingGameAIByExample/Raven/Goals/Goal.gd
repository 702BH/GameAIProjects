class_name Goal
extends Node

enum Status {INACTIVE, ACTIVE, COMPLETED, FAILED}

var owner_agent: RavenAgent
var status: Status = Status.INACTIVE

func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent

# Logic to run when the goal is activated
func activate() -> void:
	pass

# Logic to run each update-step
func process() -> Status:
	return Status.INACTIVE

# Logic to run when the goal is satisfied (used to switch off ative steering behaviours)
func terminate() -> void:
	pass


func is_active() -> bool:
	return status == Status.ACTIVE

func is_inactive() -> bool:
	return status == Status.INACTIVE

func is_completed() -> bool:
	return status == Status.COMPLETED

func has_failed() -> bool:
	return status == Status.FAILED

func activate_if_inactive() -> void:
	if is_inactive():
		activate()

func reactivate_if_failed() -> void:
	if has_failed():
		status = Status.INACTIVE
