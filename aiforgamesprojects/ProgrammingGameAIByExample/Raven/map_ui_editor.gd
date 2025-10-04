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


@onready var agent_debugger := $CollapsableDebug
@onready var debug_buttons_container := $Container/ButtonPanel/DebugMapUI


@onready var popup_placebale : PlaceablePopUp = $PlaceablePopup



var loaded_map := ""
var map_drawer

var selected_agent : RavenAgent

var processing_node: RavenNode


func _ready() -> void:
	$Container/ButtonPanel/Buttons.visible = true
	$Container/ButtonPanel/RunMapUI.visible = false
	popup_placebale.visible = false
	agent_debugger.visible = false
	debug_buttons_container.visible = false
	RavenServiceBus.weapon_popup.connect(_on_weapon_popup.bind())
	RavenServiceBus.agent_selected.connect(on_agent_selected.bind())
	RavenServiceBus.agent_delesected.connect(on_agent_deselected.bind())
	RavenServiceBus.placeable_popup_requested.connect(_on_placeable_popup_request.bind())


func _on_placeable_popup_request(node: RavenNode) -> void:
	popup_placebale.visible = true
	popup_placebale.processing_node = node
	

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
	update_debug_ui(true)

func on_agent_deselected() -> void:
	selected_agent = null
	agent_name_label.text = "None"
	update_debug_ui(false)

func _on_random_path_pressed() -> void:
	print(selected_agent)
	if selected_agent:
		selected_agent._on_generate_paths_pressed()


func _on_weapon_toggled(toggled_on: bool) -> void:
	if toggled_on:
		RavenServiceBus.mode_changed.emit(MapDrawingInput.tool_state.PLACEABLE)
	else:
		RavenServiceBus.mode_changed.emit(MapDrawingInput.tool_state.NONE)


func _on_weapon_cancel_pressed() -> void:
	weapon_popup.visible = false
	weapon_toggle.button_pressed = false


func _on_weapon_submit_pressed() -> void:
	weapon_popup.visible = false
	RavenServiceBus.submitted_weapon.emit(RavenNodeItemWeapon.WeaponSubtype.SHOTGUN)


func _on_debug_pressed() -> void:
	map_editor_ui.visible = false
	map_run_ui.visible = false
	debug_buttons_container.visible = true
	agent_debugger.visible = true




func _on_play_pressed() -> void:
	RavenServiceBus.game_start_requested.emit()


func update_debug_ui(selected: bool) -> void:
	agent_debugger.clear_systems()
	if selected:
		agent_debugger.selected_agent = selected_agent
		# set agent name
		$Container/ButtonPanel/DebugMapUI/HBoxContainer/AgentUI/selectedName.text = str(selected_agent.agent_name)
	else:
		$Container/ButtonPanel/DebugMapUI/HBoxContainer/AgentUI/selectedName.text = "None"
		agent_debugger.selected_agent = null


func _on_add_dummy_pressed() -> void:
	RavenServiceBus.dummy_agent_requested.emit()


func _on_cancel_popup_pressed() -> void:
	weapon_toggle.button_pressed = false
