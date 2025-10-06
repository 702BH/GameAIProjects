class_name WeaponRocketLauncher
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.ROCKET_LAUNCHER
	num_rounds_left = 3
	max_rounds_carried = 6
	time_next_available = 3.0
	rate_of_fire = 2
	initialise_fuzzy_module()
