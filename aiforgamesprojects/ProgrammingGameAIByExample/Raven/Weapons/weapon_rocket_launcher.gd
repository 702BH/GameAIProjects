class_name WeaponRocketLauncher
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.ROCKET_LAUNCHER
	num_rounds_left = 15
	max_rounds_carried = 30
	time_next_available = 0.0
	rate_of_fire = 1.5
	initialise_fuzzy_module()
	name = "Rocket Launcher"


func shoot_at(pos: Vector2) -> void:
	if num_rounds_left > 0 and is_ready_for_next_shot():
		var bullet = ProjectileRocket.new(pos, owner_agent)
		bullet.position = owner_agent.position
		bullet.heading = (pos - bullet.position).normalized()
		RavenServiceBus.fire_projectile.emit(bullet)
		num_rounds_left -= 1
		update_time_weapon_is_next_available()


func get_desirability(dis_to_target:float) -> float:
	if num_rounds_left == 0:
		last_desirability_score = 0
	else:
		fuzzy_module.fuzzify("DisToTarget", dis_to_target)
		fuzzy_module.fuzzify("AmmoStatus", float(num_rounds_left))
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
	
	var ammo_status: FuzzyVariable = fuzzy_module.create_flv("AmmoStatus")
	var ammo_loads : FzSet = ammo_status.add_right_shoulder_set("Ammo_Loads", 15, 30, 100)
	var ammo_okay : FzSet = ammo_status.add_triangular_set("Ammo_Okay", 0, 15, 30)
	var ammo_low : FzSet = ammo_status.add_triangular_set("Ammo_Low", 0, 0, 15)
	
	fuzzy_module.add_rule(FuzzyAnd.new([target_close, ammo_loads]), undesirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_close, ammo_okay]), undesirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_close, ammo_low]), undesirable)
	
	fuzzy_module.add_rule(FuzzyAnd.new([target_medium, ammo_loads]), very_desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_medium, ammo_okay]), very_desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_medium, ammo_low]), desirable)
	
	fuzzy_module.add_rule(FuzzyAnd.new([target_far, ammo_loads]), desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_far, ammo_okay]), undesirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_far, ammo_low]), undesirable)
