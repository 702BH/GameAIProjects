class_name PlaceablePopUp
extends Panel

@onready var selection := %PopupSelection
@onready var cancel := %CancelPopup
@onready var accept := %AcceptPopup


@onready var weapon_selection_container := $VBoxContainer/VBoxContainer/WeaponSelectable
@onready var weapon_selection := %WeaponSelection


var processing_data : SelectableData

func _ready() -> void:
	#selection.items
	for key in SelectableData.PlaceableType:
		selection.add_item(key, SelectableData.PlaceableType[key])
		#print(RavenNode.PlaceableType[key])
	for key in SelectableData.WeaponSubtype:
		weapon_selection.add_item(SelectableData.enum_map[SelectableData.WeaponSubtype[key]], SelectableData.WeaponSubtype[key])
		print(SelectableData.enum_map[SelectableData.WeaponSubtype[key]])


func _on_cancel_popup_pressed() -> void:
	# set map input state
	RavenServiceBus.mode_changed.emit(MapDrawingInput.tool_state.NONE)
	processing_data = null
	visible = false


func _on_popup_selection_item_selected(index: int) -> void:
	var item = selection.get_item_id(index)
	if item ==  RavenNode.PlaceableType.Weapon:
		weapon_selection_container.visible = true
	else:
		weapon_selection_container.visible = false


func _on_accept_popup_pressed() -> void:
	# build the message
	# at the selectable
	#var selected_placeable = selection.get_selected_id()
	#processing_data.set_placeable_type()
	processing_data.set_placeable_type(selection.get_selected_id())
