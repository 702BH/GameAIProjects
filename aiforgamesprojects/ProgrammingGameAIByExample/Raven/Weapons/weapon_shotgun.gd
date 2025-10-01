class_name WeaponShotgun
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_weapon.gd"


var num_balls_in_shell : int
var spread: float

func _init(_agent: RavenAgent) -> void:
	super(_agent)
	weapon_type = WeaponType.SHOTGUN
	num_rounds_left = 30
	max_rounds_carried = 30
	time_next_available = 2.5
	rate_of_fire = 0.5
	initialise_fuzzy_module()

func get_desirability(dis_to_target:float) -> float:
	if num_rounds_left == 0:
		last_desirability_score = 0
		#print("SHOTGUN NO AMMO")
	else:
		#print("FUZZYING SHOTGUN")
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
	var ammo_loads : FzSet = ammo_status.add_right_shoulder_set("Ammo_Loads", 30, 60, 100)
	var ammo_okay : FzSet = ammo_status.add_triangular_set("Ammo_Okay", 0, 30, 60)
	var ammo_low : FzSet = ammo_status.add_triangular_set("Ammo_Low", 0,0,30)
	
	
	
	fuzzy_module.add_rule(FuzzyAnd.new([target_close, ammo_loads]), very_desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_close, ammo_okay]), very_desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_close, ammo_low]), very_desirable)
	
	fuzzy_module.add_rule(FuzzyAnd.new([target_medium, ammo_loads]), very_desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_medium, ammo_okay]), desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_medium, ammo_low]), very_desirable)
	
	fuzzy_module.add_rule(FuzzyAnd.new([target_far, ammo_loads]), desirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_far, ammo_okay]), undesirable)
	fuzzy_module.add_rule(FuzzyAnd.new([target_far, ammo_low]), undesirable)
