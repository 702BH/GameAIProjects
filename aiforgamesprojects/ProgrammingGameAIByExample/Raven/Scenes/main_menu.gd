extends Control

@export_file("*.tscn") var map_editor




func _on_map_editor_pressed() -> void:
	get_tree().change_scene_to_file(map_editor)
