class_name RavenFeature
extends RefCounted


static func health(agent:RavenAgent) -> float:
	return agent.health / agent.max_health


static func total_weapon_strength(agent:RavenAgent) -> float:
	
	# loop over ammo in stats 
	var total_rounds_carryable := 0.0
	
	for weapon in agent.stats.max_rounds:
		total_rounds_carryable += agent.stats.max_rounds.get(weapon, 0.0)
	
	var total_rounds_carrying := 0.0
	for weapon in agent.weapon_system.weapon_map:
		total_rounds_carrying += agent.weapon_system.weapon_map.get(weapon, 0.0)
	
	var tweaker := 0.1

	
	
	
	return 0.0



func _get_max_rounds_bot_can_carry_for_weapon(type: RavenWeapon.WeaponType, agent:RavenAgent) -> float:
	return agent.stats.max_rounds.get(type, 0.0)
