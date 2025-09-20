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
