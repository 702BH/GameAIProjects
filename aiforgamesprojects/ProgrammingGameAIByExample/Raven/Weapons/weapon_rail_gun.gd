class_name WeaponRailGun
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.RAIL_GUN
	num_rounds_left = 6
	max_rounds_carried = 12
	time_next_available = 1.0
	rate_of_fire = 1
	initialise_fuzzy_module()
