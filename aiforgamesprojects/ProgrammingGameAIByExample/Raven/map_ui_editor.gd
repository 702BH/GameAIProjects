extends Control

signal map_load_request(file_path: String)
signal start_map_request

@onready var grid_container := $Container/GridContainer
@onready var map_editor_ui := $Container/ButtonPanel/Buttons
@onready var map_run_ui := $Container/ButtonPanel/RunMapUI
@onready var agent_name_label := $Container/ButtonPanel/RunMapUI/HBoxContainer/AgentUI/selectedName
@onready var weapon_popup := $WeaponTypeSelector
@onready var weapon_cancel := $WeaponTypeSelector/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer/WeaponCancel
@onready var weapon_submit := $WeaponTypeSelector/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer2/WeaponSubmit
@onready var weapon_toggle := $Container/ButtonPanel/Buttons/Weapon

var resolution := 24.0
var rows := 0
var columns := 0
var grid_world = []
var graph: RavenGraph
var loaded_map := ""
var map_drawer

var selected_agent : RavenAgent



var spawn_points := []

func _ready() -> void:
	$Container/ButtonPanel/Buttons.visible = true
	$Container/ButtonPanel/RunMapUI.visible = false
	RavenServiceBus.weapon_popup.connect(_on_weapon_popup.bind())

func _on_weapon_popup() -> void:
	print("should be visible")
	weapon_popup.visible = true

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
	selected_agent = agent
	agent_name_label.text = str(agent)

func on_agent_deselected() -> void:
	selected_agent = null
	agent_name_label.text = "None"

func _on_random_path_pressed() -> void:
	print(selected_agent)
	if selected_agent:
		selected_agent._on_generate_paths_pressed()


func _on_weapon_toggled(toggled_on: bool) -> void:
	if toggled_on:
		RavenServiceBus.mode_changed.emit(MapDrawing.tool_state.WEAPONS)
	else:
		RavenServiceBus.mode_changed.emit(MapDrawing.tool_state.NONE)


func _on_weapon_cancel_pressed() -> void:
	weapon_popup.visible = false
	weapon_toggle.button_pressed = false


func _on_weapon_submit_pressed() -> void:
	RavenServiceBus.submitted.emit()
