class_name RavenFeature
extends RefCounted


static func distance_to_item(bot: RavenAgent, type: RavenNodeItem.ItemType) -> float:
	
	var distance_to_item = bot.path_planner.get_cost_to_closest_item(type)
	
	if distance_to_item == 0.0:
		return 1
	
	var max_distance = 500.0
	var min_distance = 50.0
	
	clamp(distance_to_item, min_distance, max_distance)
	
	return distance_to_item / max_distance



static func health(agent:RavenAgent) -> float:
	return agent.health / agent.max_health


static func individual_weapon_strength(bot: RavenAgent, weapon: RavenWeapon.WeaponType) -> float:
	
	var wp :RavenWeapon = bot.weapon_system.get_weapon_from_inventory(weapon)
	
	if wp:
		return wp.num_rounds_left / _get_max_rounds_bot_can_carry_for_weapon(weapon, bot)
	return 0.0


static func total_weapon_strength(agent:RavenAgent) -> float:
	
	# loop over ammo in stats 
	var total_rounds_carryable := 0.0
	
	for weapon in agent.stats.max_rounds:
		total_rounds_carryable += agent.stats.max_rounds.get(weapon, 0.0)
	
	var total_rounds_carrying := 0.0
	for weapon in agent.weapon_system.weapon_map:
		total_rounds_carrying += agent.weapon_system.weapon_map.get(weapon, 0.0).num_rounds_left
	
	var tweaker := 0.1
	return tweaker + (1-tweaker)*(total_rounds_carrying)/total_rounds_carryable



static func _get_max_rounds_bot_can_carry_for_weapon(type: RavenWeapon.WeaponType, agent:RavenAgent) -> float:
	return agent.stats.max_rounds.get(type, 0.0)
