extends Control

@export_file("*.tscn") var map_editor
@export_file("*.tscn") var play_mode

@onready var open_map := $OpenMap

func _ready() -> void:
	RavenServiceBus.map_selected.connect(_on_map_selected.bind())

func _on_map_selected(file_path:String) -> void:
	World.load_world_from_file(file_path)


func _on_map_editor_pressed() -> void:
	get_tree().change_scene_to_file(map_editor)


func _on_play_pressed() -> void:
	open_map.root_subfolder = "res://ProgrammingGameAIByExample/Raven/Maps/"
	open_map.popup_centered()


func _on_open_map_file_selected(path: String) -> void:
	RavenServiceBus.map_selected.emit(path)
	open_map.hide()
	get_tree().change_scene_to_file(play_mode)
