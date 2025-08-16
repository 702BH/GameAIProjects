extends Node2D

var placing := false


@onready var source_button := $Control/HBoxContainer/Buttons/Source
@onready var target_button := $Control/HBoxContainer/Buttons/Target
@onready var walls_button := $Control/HBoxContainer/Buttons/Walls
@onready var buttons_container := $Control/HBoxContainer/Buttons
@onready var grid := $Control/HBoxContainer/Grid


func _ready() -> void:
	grid.source_placed.connect(on_source_placed.bind())
	grid.target_placed.connect(on_target_placed.bind())


func _on_source_toggled(toggled_on: bool) -> void:
	placing = toggled_on
	if toggled_on:
		disable_other_buttons(source_button)
		grid.placing_source = true
		print(placing)
	else:
		enable_buttons()
		


func enable_buttons() -> void:
	for child in buttons_container.get_children():
		child.disabled = false

func disable_other_buttons(selected_button: Button) -> void:
	for child in buttons_container.get_children():
		if child == selected_button:
			continue
		else:
			child.disabled = true


func on_source_placed() -> void:
	print("placed")
	source_button.button_pressed = false
	placing = false

func on_target_placed() -> void:
	target_button.button_pressed = false
	placing = false

func _on_target_toggled(toggled_on: bool) -> void:
	placing = toggled_on
	if toggled_on:
		disable_other_buttons(target_button)
		grid.placing_target = true
	else:
		enable_buttons()


func _on_walls_toggled(toggled_on: bool) -> void:
	placing= toggled_on
	if toggled_on:
		disable_other_buttons(walls_button)
		grid.placing_walls = toggled_on
	else:
		enable_buttons()
