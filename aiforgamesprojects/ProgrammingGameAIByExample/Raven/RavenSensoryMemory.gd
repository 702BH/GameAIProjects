class_name RavenSensoryMemory
extends Node


var owner_agent: RavenAgent

var memory_dict = {}



func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent


func _process(delta: float) -> void:
	update_agents_in_view()


func update_agents_in_view() -> void:
	var agents_in_view := owner_agent.vision.get_overlapping_areas()
	agents_in_view.filter(
		func(a:Area2D): return a != owner_agent.body
	)
	for a:Area2D in agents_in_view:
		var agent :RavenAgent = a.get_parent()
		if !memory_dict.has(agent):
			memory_dict[agent] = MemoryRecord.new()
		var record: MemoryRecord = memory_dict[agent]
		
		record.time_last_sensed = Time.get_ticks_msec() / 1000.0
		record.last_sensed_position = agent.position
		record.within_fov = true
	
	# debugging
	if !memory_dict.is_empty():
		print(memory_dict)
