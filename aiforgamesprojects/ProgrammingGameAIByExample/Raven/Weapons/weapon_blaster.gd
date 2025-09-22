class_name WeaponBlaster
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.BLASTER
	num_rounds_left = 5
	max_rounds_carried = 15
	time_next_available = 2.0
	rate_of_fire = 1.0


func shoot_at(pos: Vector2) -> void:
	if is_ready_for_next_shot():
		# fire
		# add bullet to world
		update_time_weapon_is_next_available()
