extends "res://ProgrammingGameAIByExample/Raven/tab_debug_node.gd"

var process_functions = {
	BrainData.Steps.ARBITRATION : Callable(debug_arbitration),
	BrainData.Steps.GOALS : Callable(debug_goals)
}

@onready var output := $VBoxContainer/Arbitration/Output
@onready var goal_tree := $VBoxContainer/GoalTree


func handle_debug_event(data: DebugData) -> void:
	var function = process_functions.get(data.step)
	function.call(data)

func debug_arbitration(data: DebugData) -> void:
	for message in data.messages:
		output.text += message + "\n"
	output.scroll_vertical = output.get_line_count()

func debug_goals(data: DebugData) -> void:
	var goal_data :GoalDataDebug = data.messages[0]
	goal_tree.clear()
	var root = goal_tree.create_item()
	goal_tree.hide_root = true
	
	_populate(goal_data, root)
	
	#var parent_goal = goal_tree.create_item(root)
	#parent_goal.set_text(0, data_dict.name)
	
	
	#
	#print("Goal Data Recieved")
	#print(data.messages[0])


func _populate(data:GoalDataDebug, parent: TreeItem) -> void:
	var goal = goal_tree.create_item(parent)
	goal.set_text(0, data.name)
	if data.children.size() > 0:
		for item: GoalDataDebug in data.children:
			_populate(item, goal)


func clear_debug() -> void:
	output.text = ""
