class_name FuzzyModule
extends RefCounted


enum Defuzzify_Method {MAX_AV, CENTROID}
enum Config {NUM_SAMPLES = 15}


# Key = String
# Value = FuzzyVariable
var variable_map = {}

# Array of FuzzyRule
var rules = []



func add_rule(antecdent, consequence) -> void:
	pass


func create_flv(var_name: String) -> void:
	pass




func fuzzify(name_of_flv : String, val: float) -> void:
	assert(variable_map.has(name_of_flv), "FLV not found")
	
	variable_map.get(name_of_flv).fuzzify(val)


func defuzzify(flv_name: String, method: Defuzzify_Method) -> float:
	assert(variable_map.has(flv_name), "FLV not found")
	set_confidences_of_consequents_zero()
	
	for rule in rules:
		rule.calculate()
	
	match method:
		Defuzzify_Method.CENTROID:
			return variable_map.get(flv_name).defuzzify_centroid(Config.NUM_SAMPLES)
		Defuzzify_Method.MAX_AV:
			return variable_map.get(flv_name).defuzzify_max_av()
		_:
			return 0.0


func set_confidences_of_consequents_zero() -> void:
	for rule in rules:
		rule.set_confidences_of_consequents_zero()
