class_name RavenSensoryMemory
extends Node2D


var owner_agent: RavenAgent

var memory_dict = {}

var memory_span := 2.0



func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent



func update_agents_in_view() -> void:
	var agents_in_view := owner_agent.vision.get_overlapping_areas()
	agents_in_view = agents_in_view.filter(
		func(a:Area2D): return a != owner_agent.body
	)
	
	#if agents_in_view.is_empty():
		#print("EMPTY")
		#return
	#else:
		#print("not empty")
	
	for a:Area2D in agents_in_view:
		var agent :RavenAgent = a.get_parent()
		if !memory_dict.has(agent):
			memory_dict[agent] = MemoryRecord.new()
		var record: MemoryRecord = memory_dict[agent]
		
		record.agent = agent
		record.time_last_sensed = Time.get_ticks_msec() / 1000.0
		record.last_sensed_position = agent.position
		record.within_fov = true
		record.shootable = true
	
	# debugging
	#if !memory_dict.is_empty():
		#print(memory_dict)


func get_recently_sensed_opponents() -> Array:
	var opponents := []
	
	var current_time = Time.get_ticks_msec() / 1000.0
	for key:RavenAgent in memory_dict:
		var record:MemoryRecord = memory_dict[key]
		if current_time - record.time_last_sensed <= memory_span:
			opponents.append(key)
	
	if opponents.is_empty():
		return []
	
	return opponents


func is_opponent_shootable(opponent: RavenAgent) -> bool:
	if memory_dict.has(opponent):
		return memory_dict[opponent].shootable
	return false
