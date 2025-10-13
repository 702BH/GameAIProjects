class_name DummyAgent
extends "res://ProgrammingGameAIByExample/Raven/raven_agent.gd"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
			var key = World.world_to_bucket(World.position_to_grid(position))
			print(key)
			var agent_bucket:Array = World.cell_buckets_agents.get(Vector2i(int(key.x),int(key.y)), [])
			print(agent_bucket)
			print(World.cell_buckets_agents)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		if selected:
			selected = false
			print("checking cells")
			var new_cell = World.position_to_grid(position)
			print("BEFORE IF")
			print("NEw cell: ", new_cell)
			print("LAst cell: ", last_cell)
			if new_cell != last_cell:
				World.move_agent(self, last_cell, new_cell)
				last_cell = new_cell
	if event.is_action_pressed("remove"):
		selected = true



func _physics_process(delta: float) -> void:
	if selected:
		position = get_global_mouse_position()


func _process(delta: float) -> void:
	queue_redraw()
