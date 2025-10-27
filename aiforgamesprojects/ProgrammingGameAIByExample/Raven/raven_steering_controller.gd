class_name RavenSteeringController
extends Node

const DecelerationTweaker := 0.3


var owner_agent : RavenAgent

var steering_force := Vector2.ZERO

var wanderRadius := 50.0
var wanderDistance := 100.0
var wanderJitter := 2
var wanderTarget := Vector2.ZERO
var targetLocal := Vector2.ZERO
var targetWorld := Vector2.ZERO
var pursuer

var neighbors := []

var target

# Behaviour settings
var behaviors = {
	"seperation" : {"active": false, "weight": 1.0},
	"seek": {"active": false, "weight": 1.0},
	"arrive": {"active": false, "weight": 1.0},
	"evade" : {"active": false, "weight":1.0},
	"alignment": {"active": false, "weight": 1.0},
	"cohesion" : {"active": false, "weight": 1.0},
	"wander": {"active": false, "weight":1.0},
	"obstacle_avoid": {"active": false, "weight":1.0}
}

func _init(_owner_agent : RavenAgent) -> void:
	owner_agent = _owner_agent


func set_behaviour(behaviour:String, status:bool, weight:float) -> void:
	if behaviors.has(behaviour):
		behaviors[behaviour]["active"] = status
		if weight >= 0.0:
			behaviors[behaviour]["weight"] = weight


func set_target(_target: Vector2) -> void:
	target =  World.grid_to_world(_target.x, _target.y)
	#print("SET TARGET")
	#print(target)

func set_target_world(_target: Vector2) -> void:
	target = _target

func reset_target() -> void:
	target = null

func calculate() -> Vector2:
	var pos = World.position_to_grid(owner_agent.position)
	var agent_bucket = World.world_to_bucket(pos)
	neighbors = World.cell_buckets_agents.get(agent_bucket, [])
	
	steering_force = Vector2.ZERO
	
	
	if behaviors["obstacle_avoid"]["active"]:
		if not accumulate_force(wall_avoidance() * behaviors["obstacle_avoid"]["weight"]):
			return steering_force
	
	if behaviors["evade"]["active"]:
		if not accumulate_force(evade(pursuer) * behaviors["evade"]["weight"]):
			return steering_force
	
	if behaviors["seperation"]["active"]:
		if not accumulate_force(seperate(neighbors) * behaviors["seperation"]["weight"]):
			return steering_force
	
	if behaviors["alignment"]["active"]:
		if not accumulate_force(allignment(neighbors) * behaviors["alignment"]["weight"]):
			return steering_force
	
	if behaviors["cohesion"]["active"]:
		if not accumulate_force(cohesion(neighbors) * behaviors["cohesion"]["weight"]):
			return steering_force
	
	if behaviors["seek"]["active"]:
		if target:
			if not accumulate_force(seek(target) * behaviors["seek"]["weight"]):
				return steering_force
	
	if behaviors["arrive"]["active"]:
		if target:
			if not accumulate_force(arrive(target) * behaviors["arrive"]["weight"]):
				return steering_force
	
	if behaviors["wander"]["active"]:
		if not accumulate_force(wander() * behaviors["wander"]["weight"]):
			return steering_force
	
	return steering_force

func accumulate_force(force_to_add:Vector2) -> bool:
	var magnitude_so_far = steering_force.length()
	var mag_remaining = owner_agent.max_force - magnitude_so_far
	if mag_remaining <= 0:
		return false
	
	var mag_to_add = force_to_add.length()
	if mag_to_add < mag_remaining:
		steering_force += force_to_add
	else:
		steering_force += force_to_add.normalized() * mag_remaining
	
	return true

func seperate(agents : Array[RavenAgent]) -> Vector2:
	var steering_force := Vector2.ZERO
	var desired_sep = 25
	var count = 0
	
	for agent : RavenAgent in agents:
		if agent == owner_agent:
			continue
		var d = owner_agent.position.distance_to(agent.position)
		if d > 0 and d < desired_sep:
			var to_vehicle = owner_agent.position - agent.position
			to_vehicle = to_vehicle.normalized()
			to_vehicle = to_vehicle / d
			steering_force += to_vehicle
			count += 1
	if count > 0:
		steering_force = steering_force / count
	if steering_force.length() > 0:
		steering_force = steering_force.normalized()
		steering_force = steering_force * owner_agent.max_speed
		steering_force = steering_force - owner_agent.velocity
		steering_force = steering_force.limit_length(owner_agent.max_force)
	return steering_force

func allignment(agents : Array[RavenAgent]) -> Vector2:
	var average_heading := Vector2.ZERO
	var neighbor_disance = 50
	var neighbor_count := 0
	
	for agent : RavenAgent in agents:
		if agent == owner_agent:
			continue
		var d = agent.position.distance_to(agent.position)
		if d > 0 and d < neighbor_disance:
			average_heading += agent.velocity
			neighbor_count += 1
	
	if neighbor_count > 0:
		average_heading = average_heading / neighbor_count
		average_heading = average_heading.normalized()
		average_heading = average_heading * owner_agent.max_speed
		var steer = average_heading - owner_agent.velocity
		steer = steer.limit_length(owner_agent.max_force)
		return steer
	else:
		return Vector2.ZERO


func cohesion(agents : Array[RavenAgent]) -> Vector2:
	var center_of_mass := Vector2.ZERO
	var neighbor_disance = 50
	var steering_force := Vector2.ZERO
	var neighbor_count := 0
	
	for agent : RavenAgent in agents:
		if agent == owner_agent:
			continue
		var d = owner_agent.position.distance_to(agent.position)
		if d > 0 and d < neighbor_disance:
			center_of_mass += agent.position
			neighbor_count +=1
	
	if neighbor_count > 0:
		center_of_mass = center_of_mass / neighbor_count
		return seek(center_of_mass)
	else:
		return Vector2.ZERO



func seek(target : Vector2) -> Vector2:
	var desired_velocity : Vector2 = (target - owner_agent.position).normalized() * owner_agent.max_speed
	var steer = (desired_velocity - owner_agent.velocity).limit_length(owner_agent.max_force)
	return steer

func arrive(target: Vector2, decel:float = 1.0) -> Vector2:
	if target == null:
		return Vector2.ZERO
	
	var to_target = target - owner_agent.position
	var dist = to_target.length()
	if dist <= 0.001:
		return Vector2.ZERO
	
	var speed = dist/ decel * DecelerationTweaker
	speed = clamp(speed,0.0, owner_agent.max_speed)
	
	var desired_velocity = to_target * speed / dist
	var steer = (desired_velocity - owner_agent.velocity).limit_length(owner_agent.max_force)
	return steer

func wander() -> Vector2:
	var steer := Vector2.ZERO
	wanderTarget += Vector2(randf_range(-1,1) * wanderJitter, randf_range(-1,1) * wanderJitter)
	wanderTarget = wanderTarget.normalized()
	wanderTarget *= wanderRadius
	targetLocal = wanderTarget + Vector2(wanderDistance, 0)
	targetWorld = targetLocal + owner_agent.position
	var desired_velocity : Vector2 = (targetWorld - owner_agent.position).normalized() * owner_agent.max_speed
	steer = (desired_velocity - owner_agent.velocity).limit_length(owner_agent.max_force)
	return steer

func evade(pursuer : RavenMover) -> Vector2:
	var steering := Vector2.ZERO
	var to_pursuer = pursuer.position - owner_agent.position
	
	var look_ahead_time = to_pursuer.length() / (owner_agent.flee_speed + pursuer.max_speed)
	
	var future_position = pursuer.position  + pursuer.velocity * look_ahead_time
	
	var desired_velocity = (owner_agent.position - future_position).normalized() * owner_agent.flee_speed
	steering = (desired_velocity - owner_agent.velocity).limit_length(owner_agent.flee_speed)
	
	return steering


func wall_avoidance() -> Vector2:
	var steering := Vector2.ZERO
	var distToThisIP :float = 0.0
	var closest_dist := INF
	
	var closest_point := Vector2.ZERO
	var closest_normal := Vector2.ZERO
	var hit_feeler := -1
	
	###
	# testing new method
	###
	
	
	# loop over agent feelers
	for i in  range(owner_agent.feelers.size()):
		var collision_point := Vector2.ZERO
		var key = World.world_to_bucket(World.position_to_grid(owner_agent.feelers[i]))
		var bucket:Array = World.cell_buckets_static.get(Vector2i(int(key.x), int(key.y)), [])
		
		var buckets_to_check = []
		
		for k in range(-1, 2):
			for l in range(-1, 2):
				var new_key = Vector2i(int(key.x) + k, int(key.y) + l)
				#print(new_key)
				var new_bucket: Array = World.cell_buckets_static.get(new_key, [])
				if new_bucket.is_empty():
					continue
				for value in new_bucket:
					buckets_to_check.append(value)
		
		
		
		if buckets_to_check.is_empty():
			continue
		for node:RavenNode in buckets_to_check:
			if node.node_type != RavenNode.NodeType.WALL:
				continue
			## Wall points
			var half_res = World.resolution /2
			var node_world_pos = World.grid_to_world(node.node_pos.x, node.node_pos.y)
			var top_left := Vector2(node_world_pos.x -half_res, node_world_pos.y -half_res)
			var top_right:= Vector2(node_world_pos.x +half_res, node_world_pos.y -half_res)
			var bottom_left:= Vector2(node_world_pos.x -half_res, node_world_pos.y +half_res)
			var bottom_right:= Vector2(node_world_pos.x +half_res, node_world_pos.y +half_res)
			var wall_segments:Array = [
				[top_left, top_right],
				[bottom_left, bottom_right],
				[top_left, bottom_left],
				[top_right, bottom_right]
			]
			for segment:Array in wall_segments:
				var calc_point : Vector2 = Calculations.line_intersection2D(owner_agent.position, owner_agent.feelers[i], segment[0], segment[1])
				if calc_point != Vector2.INF:
					var dist_sq = owner_agent.position.distance_squared_to(calc_point)
					if dist_sq < closest_dist:
						closest_dist = dist_sq
						closest_point = calc_point
						closest_normal = (segment[1] - segment[0]).orthogonal().normalized()
						var to_agent = owner_agent.position - calc_point
						if closest_normal.dot(to_agent) < 0:
							closest_normal = -closest_normal
						hit_feeler = i
	if closest_point != Vector2.ZERO and hit_feeler != -1:
		#print("Collision at", closest_point)
		#print("Feeler position: ", owner_agent.feelers[hit_feeler])
		#print(owner_agent.feelers[i])
		#print(collision_point)
		#print(owner_agent.position)
		var over_shoot = owner_agent.feelers[hit_feeler] - closest_point
		steering = closest_normal * over_shoot.length()
	
	#var dist_sq = owner_agent.position.distance_squared_to(collision_point)
	#var detection_radius = 30.0
	#if dist_sq > detection_radius * detection_radius:
		#return steering
	#var away_vector = (owner_agent.position - collision_point).normalized()
	##var strength = clamp((detection_radius - sqrt(closest_dist_sq)) / detection_radius, 0.0, 1.0)
	##var forward = owner_agent.velocity.normalized()
	#var deisred_velocity = away_vector * owner_agent.max_speed
	#steering = (deisred_velocity - owner_agent.velocity).limit_length(owner_agent.max_force)
	
	
			# Wall segment tests
			# top left -> top right
			#var collision_point :Vector2 = line_intersection2D(owner_agent.position, f, top_left, top_right)
			#if collision_point != Vector2.ZERO:
				#print("top left")
				#print(top_left)
				#print("Top Left -> Top Right: COLISSIOn")
			
			# calculate slopes
			#var tl_tr_m = (top_right.y - top_left.y) / (top_right.x - top_right.x)
			#if m1 != tl_tr_m:
				## solve for x
				#var x = (m1 * f.x - tl_tr_m * top_left.x + top_left.y - f.y) / (m1 - tl_tr_m)
				#var y = m1 * (x - f.x) + f.y
			#var x_1 = (top_left.y - b) / m1
			#if f.y == top_left.y and (x_1 >= top_left.x and x_1 <= top_right.x ):
				#print("intersect top")
				#print("point")
				#print(x_1)
				#print(f.y)
				#print("Top left")
				#print(top_left)
				#print("Top Right")
				#print(top_right)
				#print("------------")
				#break
			
			# bottom_left -> bottom_right
			#var x_2 = (bottom_left.y - b) / m1
			#if f.y == bottom_left.y and (f.x >= bottom_left.x or f.x <= bottom_right.x ):
				#print("intersect bottom")
				#break
	
	
	
	#####
	# old method
	#####
	#
	##var buckets_to_check = []
	##
	### find closest wall
	#var key = World.world_to_bucket(World.position_to_grid(owner_agent.position))
	#var bucket:Array = World.cell_buckets_static.get(Vector2i(int(key.x), int(key.y)), [])
	###print(key)
	###print(bucket)
	##
	###for k in range(-1, 2):
		###for l in range(-1, 2):
			###var new_key = Vector2i(int(key.x) + k, int(key.y) + l)
			####print(new_key)
			###var new_bucket: Array = World.cell_buckets_static.get(new_key, [])
			###if new_bucket.is_empty():
				###continue
			###for value in new_bucket:
				###buckets_to_check.append(value)
	##
	###print(buckets_to_check)
	##
	#if bucket.is_empty():
		#return Vector2.ZERO
	###print("bucket not empty")
	##
	#var closest_wall: RavenNode = null
	#var closest_dist_sq = INF
	#
	#for node:RavenNode in bucket:
		##print(node)
		#if node.node_type != RavenNode.NodeType.WALL:
			#continue
		#var dist_sq = owner_agent.position.distance_squared_to(World.grid_to_world(node.node_pos.x, node.node_pos.y))
		#if dist_sq < closest_dist_sq:
			#closest_dist_sq = dist_sq
			#closest_wall = node
	#
	#if closest_wall == null:
		##print("no closest wall")
		#return steering
	#
	#var detection_radius = 50.0
	#if closest_dist_sq > detection_radius * detection_radius:
		#return steering
	#
	## dot products
	#var agent_velocity = owner_agent.velocity.normalized()
	#var wall_vector = (World.grid_to_world(closest_wall.node_pos.x, closest_wall.node_pos.y) - owner_agent.position).normalized()
	#var dot_product = agent_velocity.dot(wall_vector)
	#
	#if dot_product >= cos(deg_to_rad(70)):
		##print("wall found")
		#var away_vector = (owner_agent.position - World.grid_to_world(closest_wall.node_pos.x, closest_wall.node_pos.y)).normalized()
		#var strength = clamp((detection_radius - sqrt(closest_dist_sq)) / detection_radius, 0.0, 1.0)
		#var forward = owner_agent.velocity.normalized()
		#var deisred_velocity = (away_vector * owner_agent.max_speed * strength *0.5 + forward)
		#
		#steering = (deisred_velocity - owner_agent.velocity).limit_length(owner_agent.max_force)
	##
	return steering

 
