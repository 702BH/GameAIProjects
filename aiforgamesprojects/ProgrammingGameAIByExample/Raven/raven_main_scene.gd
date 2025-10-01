extends Node2D


@export var width := 1152.0
@export var height := 600.0

@onready var ui := $CanvasLayer/UI
@onready var grid_container := $CanvasLayer/UI/Container/GridContainer
@onready var agent_prefab := preload("res://ProgrammingGameAIByExample/Raven/raven_agent.tscn")
@onready var agents_container := $AgentContainer
@onready var map_drawing := $MapDrawing
@onready var projectile_container := $ProjectileContainer

var resolution := 24.0
var loaded_map := ""
# grid-space partioning
var cell_size = 4



func _ready() -> void:
	World.initialise(width, height, resolution, cell_size)
	World.graph = RavenGraph.new(false)
	World.generate_grid()
	initialise_ui_container(map_drawing)
	initialise_map_drawer()
	agents_container.connect("agent_selected", ui.on_agent_selected)
	agents_container.connect("agent_deselected", ui.on_agent_deselected)
	RavenServiceBus.fire_projectile.connect(_on_projectile_fired.bind())
	RavenServiceBus.game_start_requested.connect(_on_map_start_requested.bind())

func _on_map_start_requested() -> void:
	print("MAP START REQUESTED")
	start_map()

func start_map() -> void:
	if World.loaded_map:
		spawn_agents()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		agents_container.query_selectable(get_global_mouse_position())
	if event.is_action_pressed("remove"):
		if agents_container.selected_agent:
			print("Should generate a path")

func initialise_ui_container(map_drawer) -> void:
	ui.map_drawer = map_drawer

func initialise_map_drawer() -> void:
	map_drawing.queue_redraw()



func _on_ui_map_load_request(file_path: String) -> void:
	World.load_world_from_file(file_path)
	map_drawing.queue_redraw()




func spawn_agents() -> void:
	for node:RavenNode in World.spawn_points:
		var agent : RavenAgent = agent_prefab.instantiate()
		agent.position = World.grid_to_world(node.node_pos.x, node.node_pos.y)
		if randf() > 0.3:
			agent.rotate(randf_range(-2, 2))
		agents_container.add_child(agent)
		World.place_agent(agent, World.position_to_grid(agent.position))
		agent.queue_redraw()
	
	#print(World.cell_buckets_agents)

func _on_ui_start_map_request() -> void:
	spawn_agents()


func _on_ui_map_save_request(file_name: String) -> void:
	World.save_world_to_file(file_name)


func _on_projectile_fired(projectile: RavenProjectile) -> void:
	#print("Fired")
	projectile_container.add_child(projectile)
