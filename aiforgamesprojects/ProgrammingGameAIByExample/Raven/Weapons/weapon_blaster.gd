class_name WeaponBlaster
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.BLASTER
	num_rounds_left = 5
	max_rounds_carried = 15
