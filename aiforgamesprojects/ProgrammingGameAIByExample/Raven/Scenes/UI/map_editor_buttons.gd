extends HBoxContainer


func _ready() -> void:
	RavenServiceBus.placeable_popup_submitted.connect(_on_popup_submitted.bind())

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
