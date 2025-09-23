class_name MemoryRecord
extends Node

var agent: RavenAgent
var time_last_sensed: float = 0.0
var time_became_visible: float = 0.0
var time_last_visible: float = 0.0
var last_sensed_position := Vector2.ZERO
var within_fov: bool = false
var shootable : bool = false


func _init(_agent: RavenAgent) -> void:
	agent = _agent
