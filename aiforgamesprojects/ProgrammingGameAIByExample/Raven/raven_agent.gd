class_name RavenAgent
extends RavenMover

@onready var body := $agent_body
@onready var body_shape := $agent_body/body_collision
@onready var vision :Area2D= $agent_vision
@onready var vision_shape := $agent_vision/vision_collision


var sensory_memory := RavenSensoryMemory.new(self)
var path_planner := RavenPathPlanner.new(self)
var steering_controller := RavenSteeringController.new(self)
var targeting_system := RavenTargetingSystem.new(self)
var brain := GoalThink.new(self)
var weapon_system := RavenWeaponSystem.new(self, 0.01, 1.0)


var click_radius := 15.0
var selected := false

var current_path = []

var edge_timer := 0
var exepected_time := 0.0

var last_cell


# obstacle avoidance
var closest_wall_point: Vector2


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

func _ready() -> void:
	last_cell = World.position_to_grid(position)
	var collision_shape := CircleShape2D.new()
	collision_shape.radius = radius
	body_shape.shape = collision_shape
	
	vision_shape.polygon = vision_points
	feeler_length = World.cell_size 


# debugging
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		#print("Agent: ", self)
		#print(World.world_to_bucket(World.position_to_grid(position)))
		#print(World.cell_buckets_static[Vector2i(1, 2)])
		print(self)
		print(position)
		print(feelers)


func _physics_process(delta: float) -> void:
	#rotation += 0.1 * delta
	brain.process()
	sensory_memory.update_agents_in_view()
	targeting_system.update()
	weapon_system.select_weapon()
	weapon_system.take_aim_and_shoot()
	
	var steering_force = steering_controller.calculate()
	apply_force(steering_force)
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta
	acceleration = Vector2.ZERO
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
	var tolerance := 20.0
	
	return position.distance_squared_to(pos) < tolerance * tolerance
