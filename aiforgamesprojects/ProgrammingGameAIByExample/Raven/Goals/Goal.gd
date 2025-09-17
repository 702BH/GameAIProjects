class_name Goal
extends Node

enum Status {INACTIVE, ACTIVE, COMPLETED, FAILED}

var status: Status = Status.INACTIVE


# Logic to run when the goal is activated
func activate() -> void:
	pass

# Logic to run each update-step
func process() -> void:
	pass

# Logic to run when the goal is satisfied (used to switch off ative steering behaviours)
func terminate() -> void:
	pass


func is_active() -> bool:
	return status == Status.ACTIVE

func is_completed() -> bool:
	return status == Status.COMPLETED

func has_failed() -> bool:
	return status == Status.FAILED
