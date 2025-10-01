extends "res://ProgrammingGameAIByExample/Raven/tab_debug_node.gd"


func handle_debug_event(event: Dictionary) -> void:
	var message = event.get("message")
	if message:
		print("BRAIN DEBUGGER")
		print(message)
