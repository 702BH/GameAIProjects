class_name Regulator
extends RefCounted

var update_period: float
var next_update_time

func _init(num_updates_per_second: float) -> void:
	next_update_time = Time.get_ticks_msec() + randf() *1000.0
	
	if num_updates_per_second > 0:
		update_period = 1000.0 / num_updates_per_second


func is_ready() -> bool:
	var current_time = Time.get_ticks_msec()
	var update_period_variator: float = 10.0
	
	if current_time >= next_update_time:
		next_update_time = current_time + update_period + randf_range(-update_period_variator, update_period_variator)
		return true
	
	return false
