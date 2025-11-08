extends Node2D

signal agent_selected(agent: RavenAgent)
signal agent_deselected

var selected_agent: RavenAgent

var dummy_count := 0


func _ready() -> void:
	RavenServiceBus.agent_possess_requested.connect(_on_possess_request.bind())

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if selected_agent:
		if selected_agent.is_possessed:
			draw_circle(get_global_mouse_position(), 3.0, Color.RED)


func _on_possess_request() -> void:
	#print("Possess request recievied by agent container")
	if selected_agent:
		if !selected_agent.is_possessed:
			selected_agent.is_possessed = true
			selected_agent._possessed()
		else:
			selected_agent.is_possessed = false


func query_selectable(pos: Vector2) -> void:
	if !selected_agent:
		var agent_found = false
		for agent:RavenAgent in get_children():
			agent.selected = false
			if agent is DummyAgent:
				continue
			if pos.distance_squared_to(agent.position) <= agent.click_radius * agent.click_radius:
				agent.selected = true
				selected_agent = agent
				agent_found = true
				break
		
		if agent_found:
			RavenServiceBus.agent_selected.emit(selected_agent)
			#agent_selected.emit(selected_agent)
		else:
			selected_agent = null
			RavenServiceBus.agent_delesected.emit()
			#agent_deselected.emit()
	else:
		if !selected_agent.is_possessed:
			selected_agent.selected = false
			selected_agent = null
			RavenServiceBus.agent_delesected.emit()
