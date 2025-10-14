class_name RavenAgent
extends RavenMover

@onready var body := $agent_body
@onready var body_shape := $agent_body/body_collision
@onready var vision :Area2D= $agent_vision
@onready var vision_shape := $agent_vision/vision_collision


# for debug purposes
var names = ["Jarvan", "Lulu", "Malphite", "Ryze"]
var agent_name

var sensory_memory := RavenSensoryMemory.new(self)
var path_planner := RavenPathPlanner.new(self)
var steering_controller := RavenSteeringController.new(self)
var targeting_system := RavenTargetingSystem.new(self)
var brain := GoalThink.new(self)
var weapon_system := RavenWeaponSystem.new(self, 0.01, 1.0)
var stats := RavenAgentStats.new()

# Create the regulators
var weapon_selection_regulator = Regulator.new(2.0)
var goal_arbitration_regulator = Regulator.new(4.0)
var target_selection_regulator = Regulator.new(2.0)
var vision_update_regulator = Regulator.new(4.0)
var debug_regulator = Regulator.new(1.0)

var click_radius := 15.0
var selected := false

var current_path = []

var edge_timer := 0
var exepected_time := 0.0

var last_cell


# obstacle avoidance
var closest_wall_point: Vector2

var current_goal : GoalEvaluator.GoalType
var goal_colors := {
	GoalEvaluator.GoalType.EXPLORE : Color.GREEN,
	GoalEvaluator.GoalType.ATTACK_TARGET : Color.RED
}

# vision
var vision_points :PackedVector2Array = [
	Vector2(0, -20.0),
	Vector2(140, -75.0),
	Vector2(165, -50.0),
	Vector2(165, 50),
	Vector2(140, 75),
	Vector2(0, 20)
	
]


var feeler_length = 50.0
var feelers = [Vector2.ZERO,Vector2.ZERO, Vector2.ZERO]


# Agent vals
var health := 100.0
var max_health := 100.0


func _init() -> void:
	agent_name = names[randi_range(0, names.size() - 1)]


func _ready() -> void:
	last_cell = World.position_to_grid(position)
	var collision_shape := CircleShape2D.new()
	collision_shape.radius = radius
	body_shape.shape = collision_shape
	
	vision_shape.polygon = vision_points
	feeler_length = World.cell_size 
	RavenServiceBus.agent_goal_changed.connect(_on_goal_changed.bind())
	RavenServiceBus.agent_died.connect(_on_agent_died.bind())

func _on_agent_died(agent: RavenAgent) -> void:
	# remove bot from memoery
	sensory_memory.remove_agent_from_memory(agent)
	
	# remove bot as target
	if targeting_system.current_target == agent:
		targeting_system.clear_target()



func _on_goal_changed(agent: RavenAgent, type: GoalEvaluator.GoalType) -> void:
	if agent == self:
		#print("Current goal changed to: ", type)
		current_goal = type

# debugging
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		#print("Agent: ", self)
		#print(World.world_to_bucket(World.position_to_grid(position)))
		#print(World.cell_buckets_static[Vector2i(1, 2)])
		#print("Goals for Agent: ", self)
		#if !brain.subgoals.is_empty():
			#for b:Goal in brain.subgoals:
				#print(b.Type.keys()[b.goal_type])
		pass
		#print(brain.subgoals)
		


func _physics_process(delta: float) -> void:
	#rotation += 0.1 * delta
	brain.process()
	
	if target_selection_regulator.is_ready():
		targeting_system.update()
	
	if goal_arbitration_regulator.is_ready():
		brain.arbitrate()
	
	if vision_update_regulator.is_ready():
		sensory_memory.update_agents_in_view()
	
	if weapon_selection_regulator.is_ready():
		#print("Selecting weapon: ")
		weapon_system.select_weapon()
	
	
	
	weapon_system.take_aim_and_shoot(delta)
	
	var steering_force = steering_controller.calculate()
	apply_force(steering_force)
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta
	acceleration = Vector2.ZERO
	if !targeting_system.current_target:
		rotateVehicle(delta)
	
	var heading :Vector2= velocity.normalized() * (max_speed + feeler_length)
	feelers[0] = Vector2(heading.x, heading.y) + position
	feelers[1] = Vector2(heading.x, heading.y).rotated(0.5)  + Vector2(position.x, position.y)
	feelers[2] = Vector2(heading.x, heading.y).rotated(-0.5) + Vector2(position.x, position.y)
	
	
	var new_cell = World.position_to_grid(position)
	
	if new_cell != last_cell:
		World.move_agent(self, last_cell, new_cell)
		last_cell = new_cell
	queue_redraw()

#
#func _process(delta: float) -> void:
	#queue_redraw()
	#if !current_path.is_empty():
		#
		#if edge_timer == 0:
			#edge_timer = Time.get_ticks_msec()
			#exepected_time = (current_path[0].cost / max_speed + 2.0) * 1000.0
		#
		#var elapsed := Time.get_ticks_msec() - edge_timer
		#if elapsed > exepected_time:
			#print("Time passed, recalculating")
			#_on_generate_paths_pressed()
			#edge_timer = 0
	
	# Update vision
	#sensory_memory.update_agents_in_view()
	#var oppnents := sensory_memory.get_recently_sensed_opponents()
	#if oppnents.is_empty():
		#print("no enemies")
	

func _draw() -> void:
	if selected:
		draw_circle(Vector2.ZERO, 10.0, Color(1.0, 0.3, 0.4, 0.6), true)
	
	if current_goal != null:
		draw_circle(Vector2.ZERO, 4.0, goal_colors[current_goal])
	else:
		draw_circle(Vector2.ZERO, 4.0, Color.GOLD)
	draw_line(Vector2.ZERO, Vector2(10.0,0.0), "red")
	
	
	
	draw_circle(to_local(feelers[0]), 3.0, Color.RED)
	draw_circle(to_local(feelers[1]), 3.0, Color.RED)
	draw_circle(to_local(feelers[2]), 3.0, Color.RED)
	
	if !current_path.is_empty():
		#print("drawing target:")
		var target_node:PathEdge = current_path[current_path.size()-1]
		
		draw_circle(to_local(World.grid_to_world(target_node.destination.x, target_node.destination.y)), 6.0, Color.NAVY_BLUE)
		#draw_line(Vector2.ZERO, to_local(grid_to_world(current_path[0].node_pos.x, current_path[0].node_pos.y, path_planner.resolution)), "orange")
		for edge:PathEdge in current_path:
			var color := Color.ORANGE
			draw_line(to_local(World.grid_to_world(edge.source.x, edge.source.y)), to_local(World.grid_to_world(edge.destination.x, edge.destination.y)), color)
		
		#for i in range(0, current_path.size() - 1):
			#if i == current_path.size() - 1:
				#continue
			#else:
				#draw_line(to_local(grid_to_world(current_path[i].node_pos.x, current_path[i].node_pos.y, path_planner.resolution)), to_local(grid_to_world(current_path[i+1].node_pos.x, current_path[i+1].node_pos.y, path_planner.resolution)), "orange")
	if steering_controller.target:
		draw_circle(to_local(steering_controller.target), 6.0, "green")

func _on_generate_paths_pressed() -> void:
	current_path.clear()
	#print("getting random node")
	#print(path_planner.graph.get_random_node())
	#print("agent grid pos:")
	#print(path_planner.position_to_grid(position))
	#print("getting node:")
	#print(path_planner.get_nearest_node(position).id)
	print("getting random path:")
	#print(path_planner.get_random_path(position))
	current_path = path_planner.get_random_path(position)
	edge_timer = 0
	#follow_path(current_path)
	


func follow_path(path:Array) -> void:
	if path.is_empty():
		return


func is_at_position(pos: Vector2) -> bool:
	var tolerance := 2.0
	
	return position.distance_squared_to(pos) < tolerance * tolerance


func take_damage(amount:float) -> void:
	health -= amount
	if health <= 100.0:
		print("SHOULD DIE")
		RavenServiceBus.agent_died.emit(self)
		queue_free()
	health = clamp(health, 0, 100)
	print("TAKEN DAMAGE, REAMINING HEALTH: ", health)


func add_health(amount:float) -> void:
	health += amount
	health = clamp(health, 0, 100)
	print("HEALTH ADDED, Current Health: ", health)


func can_walk_to(pos: Vector2) -> bool:
	return !Calculations.is_path_obstructed(position, pos, radius)



# --- can_step Methods ---
#
# used for strafing
#
# -------------------------
func can_step_left() -> Vector2:
	var step_distance:float = radius * 2
	var heading := Vector2(cos(rotation), sin(rotation))
	var left = Vector2(-heading.y, heading.x)
	var position_of_step = position - left * step_distance - left * radius
	
	if can_walk_to(position_of_step):
		return position_of_step 
	else:
		print("Cant walk left")
		return Vector2.ZERO


func can_step_right() -> Vector2:
	var step_distance:float = radius * 2 
	var heading := Vector2(cos(rotation), sin(rotation))
	var right = Vector2(heading.y, -heading.x)
	
	var position_of_step = position + right * step_distance + right * radius
	
	if can_walk_to(position_of_step):
		return position_of_step 
	else:
		return Vector2.ZERO


func can_step_forward() -> Vector2:
	var step_distance:float = radius * 2
	var facing := velocity.normalized()
	
	var position_of_step = position + facing * step_distance + facing * radius
	
	if can_walk_to(position_of_step):
		return position_of_step
	else:
		return Vector2.ZERO

func can_step_backward() -> Vector2:
	var step_distance:float = radius * 2
	var facing := velocity.normalized()
	
	var position_of_step = position - facing * step_distance - facing * radius
	
	if can_walk_to(position_of_step):
		return position_of_step
	else:
		return Vector2.ZERO
