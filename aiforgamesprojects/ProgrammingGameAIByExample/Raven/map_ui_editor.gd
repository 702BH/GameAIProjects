extends Control

signal map_load_request(file_path: String)
signal map_save_request(file_name: String)
signal start_map_request

@onready var grid_container := $Container/GridContainer
@onready var map_editor_ui := $Container/ButtonPanel/Buttons
@onready var map_run_ui := $Container/ButtonPanel/RunMapUI
@onready var agent_name_label := $Container/ButtonPanel/RunMapUI/HBoxContainer/AgentUI/selectedName
@onready var weapon_popup := $WeaponTypeSelector
@onready var weapon_cancel := $WeaponTypeSelector/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer/WeaponCancel
@onready var weapon_submit := $WeaponTypeSelector/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer2/WeaponSubmit
@onready var weapon_toggle := $Container/ButtonPanel/Buttons/Weapon

var loaded_map := ""
var map_drawer

var selected_agent : RavenAgent


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
	map_save_request.emit(str($Container/ButtonPanel/Buttons/MapName.text))


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
	weapon_popup.visible = false
	RavenServiceBus.submitted_weapon.emit(RavenNodeItemWeapon.WeaponSubtype.SHOTGUN)


func _on_debug_pressed() -> void:
	pass # Replace with function body.
