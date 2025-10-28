extends Node

var debug_mode := true



func set_debug_mode(mode:bool) -> void:
	debug_mode = mode
	RavenServiceBus.debg_mode_changed.emit(mode)
