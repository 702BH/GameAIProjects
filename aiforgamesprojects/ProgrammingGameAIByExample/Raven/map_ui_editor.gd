extends Control

signal map_load_request(file_path: String)
signal start_map_request

@onready var grid_container := $Container/GridContainer
@onready var map_editor_ui := $Container/ButtonPanel/Buttons
@onready var map_run_ui := $Container/ButtonPanel/RunMapUI
@onready var agent_name_label := $Container/ButtonPanel/RunMapUI/HBoxContainer/AgentUI/selectedName

var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var graph: RavenGraph
var loaded_map := ""
var map_drawer



var spawn_points := []

func _ready() -> void:
	$Container/ButtonPanel/Buttons.visible = true
	$Container/ButtonPanel/RunMapUI.visible = false


func _on_walls_toggled(toggled_on: bool) -> void:
	if toggled_on:
		map_drawer.update_tool_state(MapDrawing.tool_state.WALL)
	else:
		map_drawer.update_tool_state(MapDrawing.tool_state.NONE)


func _on_spawn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		map_drawer.update_tool_state(MapDrawing.tool_state.SPAWNS)
	else:
		map_drawer.update_tool_state(MapDrawing.tool_state.NONE)


func _on_save_pressed() -> void:
	var save_data = {
		"rows":rows,
		"columns": columns,
		"resolution": resolution,
		"nodes": []
	}
	for row in range(rows):
		for col in range(columns):
			var node: RavenNode = grid_world[row][col]
			save_data["nodes"].append({
				"type": node.node_type,
				"position": {"x":node.node_pos.x, "y":node.node_pos.y},
				"row": row,
				"column": col
			})
	
	var file_path = "res://ProgrammingGameAIByExample/Raven/Maps/" + str($Container/ButtonPanel/Buttons/MapName.text + ".json")
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_line(json_string)
	file.close()


func _on_load_pressed() -> void:
	$LoadMapDialog.root_subfolder = "res://ProgrammingGameAIByExample/Raven/Maps/"
	$LoadMapDialog.popup_centered()


func _on_load_map_dialog_file_selected(path: String) -> void:
	map_load_request.emit(path)
	$LoadMapDialog.hide()
	#loaded_map = path
	#print(loaded_map)
	#load_world_from_file(loaded_map)



func _on_run_map_pressed() -> void:
	map_editor_ui.visible = false
	map_run_ui.visible = true
	map_drawer.current_ui_state = MapDrawing.ui_state.MAP_RUNNING
	start_map_request.emit()

func on_agent_selected(agent: RavenAgent) -> void:
	agent_name_label.text = str(agent)
