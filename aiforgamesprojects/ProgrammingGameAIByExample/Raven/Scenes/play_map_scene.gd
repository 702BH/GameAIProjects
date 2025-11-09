extends Node2D

@export var buttons : PackedScene
@export_file("*.tscn") var main_menu


@onready var world_sprite := $WorldSprite
@onready var ui_base := $UI/UIBase
@onready var weapon_trigger_prefab := preload("res://ProgrammingGameAIByExample/Raven/Items/trigger_weapon.tscn")
@onready var health_trigger_prefab := preload("res://ProgrammingGameAIByExample/Raven/Items/trigger_health.tscn")
@onready var sound_trigger_prefab := preload("res://ProgrammingGameAIByExample/Raven/Items/trigger_sound.tscn")
@onready var agent_prefab := preload("res://ProgrammingGameAIByExample/Raven/raven_agent.tscn")
@onready var agent_container := $AgentContainer
@onready var trigger_container := $TriggersContainer
@onready var projectile_container := $ProjectileContainer


var agent_count := 0

func _ready() -> void:
	print("Spawn array size ", World.spawn_points.size())
	DebugSettings.debug_mode = false
	# Connect signals
	RavenServiceBus.game_start_requested.connect(_on_map_start_requested.bind())
	RavenServiceBus.projectile_sound.connect(_on_projectile_sound.bind())
	RavenServiceBus.fire_projectile.connect(_on_projectile_fired.bind())
	RavenServiceBus.agent_died.connect(_on_agent_died.bind())
	
	# set up buttons
	var buttons :HBoxContainer = buttons.instantiate()
	ui_base.add_buttons(buttons)
	
	# load map texture
	if World.current_texture:
		world_sprite.texture = World.current_texture
	else:
		
		#print("PLAY MAP SHOULD BE LOADED")
		if World.current_map_name:
			#print("HAS MAP")
			#print(World.current_map_name)
			var file_name: String = World.current_map_name
			file_name = file_name.get_slice(".", 0)
			#print(file_name)
			var loaded_img := load("res://ProgrammingGameAIByExample/Raven/Maps/Images/" + file_name + ".png")
			world_sprite.texture = loaded_img


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		agent_container.query_selectable(get_global_mouse_position())

func set_up_triggers() -> void:
	# grid generated
	# instantiate the triggers
	if World.triggers.is_empty():
		pass
		
	for node: RavenNode in World.triggers:
		# if item type is weapon, we need weapon trigger
		if node.item_type.item_type == RavenNodeItem.ItemType.WEAPON:
			var weapon_trigger : WeaponTrigger = weapon_trigger_prefab.instantiate()
			trigger_container.add_child(weapon_trigger)
			weapon_trigger.initialise(World.resolution, World.resolution, node.item_type.item_sub_type)
			weapon_trigger.position = World.grid_to_world(node.node_pos.x, node.node_pos.y)
			node.item_type.set_associated_trigger(weapon_trigger)
		elif node.item_type.item_type == RavenNodeItem.ItemType.HEALTH:
			var health_trigger : HealthTrigger = health_trigger_prefab.instantiate()
			trigger_container.add_child(health_trigger)
			health_trigger.initialise(World.resolution, World.resolution)
			health_trigger.position = World.grid_to_world(node.node_pos.x, node.node_pos.y)
			node.item_type.set_associated_trigger(health_trigger)


func spawn_agents() -> void:
	for node:RavenNode in World.spawn_points:
		#print(node.node_pos.x, node.node_pos.y)
		var agent : RavenAgent = agent_prefab.instantiate()
		agent.position = World.grid_to_world(node.node_pos.x, node.node_pos.y)
		#print(agent.position)
		if randf() > 0.3:
			agent.rotate(randf_range(-2, 2))
		agent_container.add_child(agent)
		agent_count +=1
		agent.visible = false
		agent.set_physics_process(false)
		World.place_agent(agent, World.position_to_grid(agent.position))
		agent.queue_redraw()
	RavenServiceBus.game_ready.emit()


func _on_map_start_requested() -> void:
	set_up_triggers()
	spawn_agents()

func _on_projectile_sound(fired_by: RavenAgent, sound:float) -> void:
	var sound_trigger : SoundTrigger = sound_trigger_prefab.instantiate()
	trigger_container.add_child(sound_trigger)
	sound_trigger.initialise(sound, sound, fired_by)
	sound_trigger.position = fired_by.position

func _on_projectile_fired(projectile: RavenProjectile) -> void:
	#print("Fired")
	projectile_container.add_child(projectile)


func _on_agent_died(agent:RavenAgent) -> void:
	agent_count -= 1
	if agent_count <= 1:
		get_tree().change_scene_to_file(main_menu)
