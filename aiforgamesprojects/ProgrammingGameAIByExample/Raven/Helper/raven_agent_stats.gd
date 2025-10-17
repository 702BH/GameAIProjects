class_name RavenAgentStats
extends RefCounted


var max_rounds = {
	RavenWeapon.WeaponType.SHOTGUN: 15.0
}

var accuracy := 70.0



func accuracy_to_variance(min_spread:float, max_spread:float) -> float:
	var factor = 1.0 - clamp(accuracy / 100.0,0.0, 1.0)
	#print("Factor: ", factor)
	return lerp(min_spread, max_spread, factor)
