class_name WeaponBlaster
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.BLASTER
	num_rounds_left = 5
	max_rounds_carried = 15
	time_next_available = 0.0
	rate_of_fire = 3.0


func shoot_at(pos: Vector2) -> void:
	if is_ready_for_next_shot():
		# fire
		# add bullet to world
		var bullet = ProjectileBolt.new(pos)
		bullet.position = owner_agent.position
		bullet.heading = (pos - bullet.position).normalized()
		RavenServiceBus.fire_projectile.emit(bullet)
		update_time_weapon_is_next_available()
