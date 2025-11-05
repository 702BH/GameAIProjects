extends Control

@onready var button_container := $Container/PanelContainer



func add_buttons(buttons: HBoxContainer) -> void:
	button_container.add_child(buttons)
