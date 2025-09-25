class_name RavenFeature
extends RefCounted


static func health(agent:RavenAgent) -> float:
	return agent.health / agent.max_health


static func total_weapon_strength(agent:RavenAgent) -> float:
	
	return 0.0



func _get_max_rounds_bot_can_carry_for_weapon(type: RavenWeapon.WeaponType) -> float:
	return 0.0
