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
	target = _target

func reset_target() -> void:
	target = null

func calculate() -> Vector2:
	var pos = World.position_to_grid(owner_agent.position)
	var agent_bucket = World.world_to_bucket(pos)
	neighbors = World.cell_buckets_agents[agent_bucket]
	
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
	
	# find closest wall
	var key = World.position_to_grid(owner_agent.position)
	var bucket:Array = World.cell_buckets_static[key]
	
	if bucket.is_empty():
		return Vector2.ZERO
	
	var closest_wall: RavenNode = null
	var closest_dist_sq = INF
	
	for node:RavenNode in bucket:
		if node.node_type != RavenNode.NodeType.WALL:
			continue
		var dist_sq = owner_agent.position.distance_squared_to(World.grid_to_world(node.node_pos.x, node.node_pos.y))
		if dist_sq < closest_dist_sq:
			closest_dist_sq = dist_sq
			closest_wall = node
	
	if closest_wall == null:
		return steering
	
	var detection_radius = 50.0
	if closest_dist_sq > detection_radius * detection_radius:
		return steering
	
	var away_vector = (owner_agent.position - World.grid_to_world(closest_wall.node_pos.x, closest_wall.node_pos.y))
	var deisred_velocity = away_vector * owner_agent.max_speed
	
	steering = (deisred_velocity - owner_agent.velocity).limit_length(owner_agent.max_force)
	
	return steering
