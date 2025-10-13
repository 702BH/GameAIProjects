class_name RavenTargetingSystem
extends Node


var owner_agent : RavenAgent
var current_target : RavenAgent

func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent


func update() -> void:
	var closest_so_far := INF
	current_target = null
	
	var sensed_bots := owner_agent.sensory_memory.get_recently_sensed_opponents()
	
	if sensed_bots.is_empty():
		return
	
	for agent:RavenAgent in sensed_bots:
		if agent != owner_agent:
			var dist:float = agent.position.distance_squared_to(owner_agent.position)
			
			if dist < closest_so_far:
				closest_so_far = dist
				current_target = agent
	
	# debug
	#if current_target:
		#print(current_target)

func get_time_target_has_been_visible() -> float:
	if current_target:
		return owner_agent.sensory_memory.get_time_opponent_has_been_visible(current_target)
	return 0.0


func is_target_shootable() -> bool:
	if current_target:
		return owner_agent.sensory_memory.is_opponent_shootable(current_target)
	return false


func clear_target() -> void:
	current_target = null
