extends Node2D

signal agent_selected(agent: RavenAgent)
signal agent_deselected

var selected_agent: RavenAgent


func _draw() -> void:
	draw_circle(Vector2(228, 60), 2.0, "red")
	draw_circle(Vector2(229, 63), 2.0, "orange")


func query_selectable(pos: Vector2) -> void:
	var agent_found = false
	for agent:RavenAgent in get_children():
		agent.selected = false
		if pos.distance_squared_to(agent.position) <= agent.click_radius * agent.click_radius:
			agent.selected = true
			selected_agent = agent
			agent_found = true
			break
	
	if agent_found:
		agent_selected.emit(selected_agent)
	else:
		selected_agent = null
		agent_deselected.emit()
