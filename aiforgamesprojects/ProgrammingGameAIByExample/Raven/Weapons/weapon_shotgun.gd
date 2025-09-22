class_name WeaponShotgun
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.SHOTGUN
	num_rounds_left = 2
	max_rounds_carried = 6
	time_next_available = 2.5
	rate_of_fire = 0.5
	
