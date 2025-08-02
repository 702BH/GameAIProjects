class_name SheepSteeringController
extends Node


var owner_sheep : Sheep

var steering_force := Vector2.ZERO

var wanderRadius := 50.0
var wanderDistance := 100.0
var wanderJitter := 2
var wanderTarget := Vector2.ZERO
var targetLocal := Vector2.ZERO
var targetWorld := Vector2.ZERO
var pursuer

# Behaviour settings
var behaviors = {
	"seperation" : {"active": false, "weight": 1.0},
	"evade" : {"active": false, "weight":1.0},
	"alignment": {"active": false, "weight": 1.0},
	"cohesion" : {"active": false, "weight": 1.0},
	"wander": {"active": false, "weight":1.0}
}

func _init(context_owner_sheep : Sheep) -> void:
	owner_sheep = context_owner_sheep


func calculate() -> Vector2:
	steering_force = Vector2.ZERO
	
	if behaviors["evade"]["active"]:
		if not accumulate_force(evade(pursuer) * behaviors["evade"]["weight"]):
			return steering_force
	
	if behaviors["seperation"]["active"]:
		if not accumulate_force(seperate(owner_sheep.flock) * behaviors["seperation"]["weight"]):
			return steering_force
	
	if behaviors["alignment"]["active"]:
		if not accumulate_force(allignment(owner_sheep.flock) * behaviors["alignment"]["weight"]):
			return steering_force
	
	if behaviors["cohesion"]["active"]:
		if not accumulate_force(cohesion(owner_sheep.flock) * behaviors["cohesion"]["weight"]):
			return steering_force
	
	if behaviors["wander"]["active"]:
		if not accumulate_force(wander() * behaviors["wander"]["weight"]):
			return steering_force
	
	return steering_force

func accumulate_force(force_to_add:Vector2) -> bool:
	var magnitude_so_far = steering_force.length()
	var mag_remaining = owner_sheep.max_force - magnitude_so_far
	if mag_remaining <= 0:
		return false
	
	var mag_to_add = force_to_add.length()
	if mag_to_add < mag_remaining:
		steering_force += force_to_add
	else:
		steering_force += force_to_add.normalized() * mag_remaining
	
	return true

func seperate(flock : Array[Sheep]) -> Vector2:
	var steering_force := Vector2.ZERO
	var desired_sep = 25
	var count = 0
	
	for sheep : Sheep in flock:
		if sheep == self:
			continue
		var d = owner_sheep.position.distance_to(sheep.position)
		if d > 0 and d < desired_sep:
			var to_vehicle = owner_sheep.position - sheep.position
			to_vehicle = to_vehicle.normalized()
			to_vehicle = to_vehicle / d
			steering_force += to_vehicle
			count += 1
	if count > 0:
		steering_force = steering_force / count
	if steering_force.length() > 0:
		steering_force = steering_force.normalized()
		steering_force = steering_force * owner_sheep.max_speed
		steering_force = steering_force - owner_sheep.velocity
		steering_force = steering_force.limit_length(owner_sheep.max_force)
	return steering_force

func allignment(flock : Array[Sheep]) -> Vector2:
	var average_heading := Vector2.ZERO
	var neighbor_disance = 50
	var neighbor_count := 0
	
	for sheep : Sheep in flock:
		if sheep == self:
			continue
		var d = owner_sheep.position.distance_to(sheep.position)
		if d > 0 and d < neighbor_disance:
			average_heading += sheep.velocity
			neighbor_count += 1
	
	if neighbor_count > 0:
		average_heading = average_heading / neighbor_count
		average_heading = average_heading.normalized()
		average_heading = average_heading * owner_sheep.max_speed
		var steer = average_heading - owner_sheep.velocity
		steer = steer.limit_length(owner_sheep.max_force)
		return steer
	else:
		return Vector2.ZERO


func cohesion(flock : Array[Sheep]) -> Vector2:
	var center_of_mass := Vector2.ZERO
	var neighbor_disance = 50
	var steering_force := Vector2.ZERO
	var neighbor_count := 0
	
	for sheep : Sheep in flock:
		if sheep == self:
			continue
		var d = owner_sheep.position.distance_to(sheep.position)
		if d > 0 and d < neighbor_disance:
			center_of_mass += sheep.position
			neighbor_count +=1
	
	if neighbor_count > 0:
		center_of_mass = center_of_mass / neighbor_count
		return seek(center_of_mass)
	else:
		return Vector2.ZERO



func seek(target : Vector2) -> Vector2:
	var desired_velocity : Vector2 = (target - owner_sheep.position).normalized() * owner_sheep.max_speed
	var steer = (desired_velocity - owner_sheep.velocity).limit_length(owner_sheep.max_force)
	return steer


func wander() -> Vector2:
	var steer := Vector2.ZERO
	wanderTarget += Vector2(randf_range(-1,1) * wanderJitter, randf_range(-1,1) * wanderJitter)
	wanderTarget = wanderTarget.normalized()
	wanderTarget *= wanderRadius
	targetLocal = wanderTarget + Vector2(wanderDistance, 0)
	targetWorld = targetLocal + owner_sheep.position
	var desired_velocity : Vector2 = (targetWorld - owner_sheep.position).normalized() * owner_sheep.max_speed
	steer = (desired_velocity - owner_sheep.velocity).limit_length(owner_sheep.max_force)
	return steer

func evade(pursuer : MoverBase) -> Vector2:
	var steering := Vector2.ZERO
	var to_pursuer = pursuer.position - owner_sheep.position
	
	var look_ahead_time = to_pursuer.length() / (owner_sheep.flee_speed + pursuer.max_speed)
	
	var future_position = pursuer.position  + pursuer.velocity * look_ahead_time
	
	var desired_velocity = (owner_sheep.position - future_position).normalized() * owner_sheep.flee_speed
	steering = (desired_velocity - owner_sheep.velocity).limit_length(owner_sheep.flee_speed)
	
	return steering
