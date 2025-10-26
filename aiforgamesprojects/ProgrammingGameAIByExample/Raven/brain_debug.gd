extends "res://ProgrammingGameAIByExample/Raven/tab_debug_node.gd"

var process_functions = {
	BrainData.Steps.ARBITRATION : Callable(debug_arbitration),
	BrainData.Steps.GOALS : Callable(debug_goals)
}

@onready var output := $VBoxContainer/Arbitration/Output


func handle_debug_event(data: DebugData) -> void:
	var function = process_functions.get(data.step)
	function.call(data)

func debug_arbitration(data: DebugData) -> void:
	for message in data.messages:
		output.text += message + "\n"
	output.scroll_vertical = output.get_line_count()

func debug_goals(data: DebugData) -> void:
	print("Goal Data Recieved")
	print(data.messages[0])

func clear_debug() -> void:
	output.text = ""
