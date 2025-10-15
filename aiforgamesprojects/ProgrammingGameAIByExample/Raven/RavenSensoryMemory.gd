class_name RavenSensoryMemory
extends RefCounted


var owner_agent: RavenAgent

var memory_dict = {}

var memory_span := 3.0



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
			memory_dict[agent] = MemoryRecord.new(agent)
		var record: MemoryRecord = memory_dict[agent]
		
		if !Calculations.do_walls_obstruct_line_segment(owner_agent.position, agent.position):
			record.shootable = true
			print("NOT OBSTRUCTED")
			# FOV check
			var agent_velocity = owner_agent.velocity.normalized()
			var target_vector = (agent.position - owner_agent.position).normalized()
			var dot_product = agent_velocity.dot(target_vector)
			
			if dot_product >= cos(deg_to_rad(40)):
				# in fov
				if !record.within_fov:
					# was not in view before
					record.within_fov = true
					record.time_became_visible  =  Time.get_ticks_msec() / 1000.0
					record.time_last_sensed = Time.get_ticks_msec() / 1000.0
					record.last_sensed_position = agent.position
				else:
					record.time_last_sensed = Time.get_ticks_msec() / 1000.0
					record.last_sensed_position = agent.position
			else:
				record.within_fov = false
		else:
			print("OBSTRUCTED!")
			record.shootable = false
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


func get_time_opponent_has_been_visible(opponent: RavenAgent) -> float:
	if memory_dict.has(opponent):
		return Time.get_ticks_msec() / 1000.0 - memory_dict[opponent].time_became_visible
	return 0.0


func is_opponent_shootable(opponent: RavenAgent) -> bool:
	if memory_dict.has(opponent):
		return memory_dict[opponent].shootable
	return false

func is_opponent_within_fov(target: RavenAgent) -> bool:
	if memory_dict.has(target):
		return memory_dict[target].within_fov
	return false

func remove_agent_from_memory(agent: RavenAgent) -> void:
	memory_dict.erase(agent)

func get_last_recorded_position_of_opponent(agent:RavenAgent) -> Vector2:
	if memory_dict.has(agent):
		return memory_dict[agent].last_sensed_position
	return Vector2.ZERO

func update_with_sound_source(agent: RavenAgent) -> void:
	if agent != owner_agent:
		print("UPDATING WITH SOUND SOURCE")
		if !memory_dict.has(agent):
			memory_dict[agent] = MemoryRecord.new(agent)
		var record: MemoryRecord = memory_dict[agent]
		# FOV check
		var agent_velocity = owner_agent.velocity.normalized()
		var target_vector = (agent.position - owner_agent.position).normalized()
		var dot_product = agent_velocity.dot(target_vector)
		
		if dot_product >= cos(deg_to_rad(40)):
			# in fov
			if !record.within_fov:
				# was not in view before
				record.within_fov = true
				record.time_became_visible  =  Time.get_ticks_msec() / 1000.0
				record.time_last_sensed = Time.get_ticks_msec() / 1000.0
				record.last_sensed_position = agent.position
				record.shootable = true
			else:
				record.time_last_sensed = Time.get_ticks_msec() / 1000.0
				record.last_sensed_position = agent.position
				record.shootable = true
		else:
			record.within_fov = false
			record.shootable = false
	else:
		print("FIRED BY THIS AGENT")
