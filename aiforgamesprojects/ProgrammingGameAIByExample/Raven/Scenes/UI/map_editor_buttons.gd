extends HBoxContainer


@onready var map_name := $MapName

func _ready() -> void:
	RavenServiceBus.placeable_popup_submitted.connect(_on_popup_submitted.bind())
	RavenServiceBus.map_selected.connect(_on_map_selected.bind())

func _on_walls_toggled(toggled_on: bool) -> void:
	if toggled_on:
		RavenServiceBus.mode_changed.emit(MapDrawing.tool_state.WALL)
	else:
		RavenServiceBus.mode_changed.emit(MapDrawing.tool_state.NONE)


func _on_placeables_toggled(toggled_on: bool) -> void:
	if toggled_on:
		RavenServiceBus.mode_changed.emit(MapDrawingInput.tool_state.PLACEABLE)
	else:
		RavenServiceBus.mode_changed.emit(MapDrawingInput.tool_state.NONE)


func _on_popup_submitted(data: SelectableData) -> void:
	for children in get_children():
		if children is Button:
			children.button_pressed = false


func _on_load_map_pressed() -> void:
	RavenServiceBus.load_map_pressed.emit()

func _on_map_selected(file_path:String) -> void:
	var file_name = file_path.get_slice("/", file_path.get_slice_count("/") -1)
	map_name.text = file_name


func _on_save_map_pressed() -> void:
	RavenServiceBus.map_save_request.emit(str(map_name.text))
