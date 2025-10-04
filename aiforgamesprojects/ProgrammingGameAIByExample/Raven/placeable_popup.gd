class_name PlaceablePopUp
extends Panel

@onready var selection := %PopupSelection
@onready var cancel := %CancelPopup
@onready var accept := %AcceptPopup


var processing_node : RavenNode


func _on_cancel_popup_pressed() -> void:
	# set map input state
	RavenServiceBus.mode_changed.emit(MapDrawingInput.tool_state.NONE)
	processing_node = null
	visible = false
