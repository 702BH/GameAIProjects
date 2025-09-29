class_name RavenWeaponSystem
extends Node


var owner_agent : RavenAgent
var current_weapon: RavenWeapon
var reaction_time : float
var aim_accuracy : float

# key = WeaponType enum, value = pointer to weapon carrying
var weapon_map : Dictionary = {}


func _init(_agent: RavenAgent, _react_time: float, _acc: float) -> void:
	owner_agent = _agent
	reaction_time = _react_time
	aim_accuracy = _acc
	current_weapon = WeaponBlaster.new(owner_agent)
	
	weapon_map.clear()
	
	weapon_map[RavenWeapon.WeaponType.BLASTER] = current_weapon
	weapon_map[RavenWeapon.WeaponType.SHOTGUN] = WeaponShotgun.new(owner_agent)

func predict_future_position_of_target() -> Vector2:
	return Vector2.ZERO

func add_noise_to_aim(aiming_pos: Vector2) -> Vector2:
	return Vector2(aiming_pos.x + randf_range(-0.5, 0.5), aiming_pos.y + randf_range(-0.5, 0.5))

func take_aim_and_shoot() -> void:
	if owner_agent.targeting_system.is_target_shootable():
		#print("target shootable")
		if owner_agent.targeting_system.current_target:
			var aiming_pos: Vector2 = owner_agent.targeting_system.current_target.position
			
			# if weapon aimed correctly
			# if been in view for period longer than reaction time
			# shoot
			if owner_agent.targeting_system.get_time_target_has_been_visible() > reaction_time:
				#aiming_pos = add_noise_to_aim(aiming_pos)
				current_weapon.shoot_at(aiming_pos)

func select_weapon() -> void:
	if owner_agent.targeting_system.current_target:
		# calculate distance to the target
		var dist_target = owner_agent.position.distance_to(owner_agent.targeting_system.current_target.position)
		
		if dist_target > 1000.0:
			return
		
		# for each weapon in the inventory calculate its desirability
		# most desirable weapon is selected
		var best_so_far : float  = -INF
		for key in weapon_map:
			var curr_weapon = weapon_map.get(key,null)
			print("Current weapon evaluating: ", RavenWeapon.WeaponType.keys()[curr_weapon.weapon_type])
			if curr_weapon:
				var score: float = curr_weapon.get_desirability(dist_target)
				print("Current weapon evaluating: ", RavenWeapon.WeaponType.keys()[curr_weapon.weapon_type])
				print("Score: ", score)
				if score > best_so_far:
					best_so_far = score
					current_weapon = curr_weapon
		print("Target found.")
		print("Weapon selected: ")
		print(RavenWeapon.WeaponType.keys()[current_weapon.weapon_type])
	else:
		print("No target, selecting: ", )
		current_weapon = weapon_map[RavenWeapon.WeaponType.BLASTER]
		print(RavenWeapon.WeaponType.keys()[current_weapon.weapon_type])

func add_weapon(weapon_type: RavenWeapon.WeaponType) -> void:
	
	var w: RavenWeapon
	
	match weapon_type:
		RavenWeapon.WeaponType.SHOTGUN:
			w = WeaponShotgun.new(owner_agent)
		RavenWeapon.WeaponType.BLASTER:
			w = WeaponBlaster.new(owner_agent)
	
	
	var present: RavenWeapon = weapon_map.get( w.weapon_type)
	
	if present:
		# add ammo
		present.increment_rounds(w.num_rounds_left)
	else:
		weapon_map[w.weapon_type] = w


func change_weapon(weapon_type: RavenWeapon.WeaponType) -> void:
	var w = weapon_map.get(weapon_type, null)
	if w:
		current_weapon = w


func get_current_weapon() -> RavenWeapon:
	return current_weapon


func get_weapon_from_inventory(weapon: RavenWeapon.WeaponType) -> RavenWeapon:
	return weapon_map.get(weapon, null)
