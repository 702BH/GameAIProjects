class_name WeaponBlaster
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.BLASTER
	num_rounds_left = 5
	max_rounds_carried = 15
	time_next_available = 0.0
	rate_of_fire = 3.0
	initialise_fuzzy_module()


func shoot_at(pos: Vector2) -> void:
	if is_ready_for_next_shot():
		# fire
		# add bullet to world
		var bullet = ProjectileBolt.new(pos)
		bullet.position = owner_agent.position
		bullet.heading = (pos - bullet.position).normalized()
		RavenServiceBus.fire_projectile.emit(bullet)
		update_time_weapon_is_next_available()


func get_desirability(dis_to_target:float) -> float:
	# fuzzify distance and amount of ammo
	fuzzy_module.fuzzify("DisToTarget", dis_to_target)
	
	last_desirability_score = fuzzy_module.defuzzify("Desirability", FuzzyModule.Defuzzify_Method.MAX_AV)
	
	
	return last_desirability_score


func initialise_fuzzy_module() -> void:
	var dist_to_target : FuzzyVariable = fuzzy_module.create_flv("DisToTarget")
	var target_close: FzSet = dist_to_target.add_left_shoulder_set("Target_Close", 0, 25, 150)
	var target_medium: FzSet = dist_to_target.add_triangular_set("Target_Medium", 25, 150, 300)
	var target_far: FzSet = dist_to_target.add_right_shoulder_set("Target_Far", 150, 300, 1000)
	
	var desirability : FuzzyVariable = fuzzy_module.create_flv("Desirability")
	var very_desirable : FzSet = desirability.add_right_shoulder_set("Very_Desirable", 50, 75, 100)
	var desirable : FzSet = desirability.add_triangular_set("Desirable", 25, 50, 75)
	var undesirable : FzSet = desirability.add_left_shoulder_set("Undesirable", 0, 25, 50)
	
	fuzzy_module.add_rule(target_close, desirable)
	fuzzy_module.add_rule(target_medium, FzVery.new(undesirable))
	fuzzy_module.add_rule(target_far, FzVery.new(undesirable))
	
