class_name FuzzyVariable
extends RefCounted


# map of fuzzy sets
# key = string
# value = FuzzySet instance

var member_sets = {}

var min_range: float
var max_range: float


func fuzzify(val:float) -> void:
	assert(val >= min_range and val <= min_range, "Value out of range")
	
	for key in member_sets:
		member_sets[key].calculate_dom(val)


func defuzzify_max_av() -> float:
	var bottom: float = 0.0
	var top : float = 0.0
	
	for key in member_sets:
		bottom += member_sets[key].get_dom()
		top += member_sets[key].get_representative_value() *  member_sets[key].get_dom()
	
	if bottom == 0.0:
		return 0.0
	
	return top/bottom



func defuzzify_centroid(num_samples:int) -> float:
	var step_size :float = (max_range - min_range)/float(num_samples)
	
	var total_area := 0.0
	var sum_of_moments := 0.0
	
	for sample in range(1, num_samples + 1):
		for key in member_sets:
			var contribution :float = min(member_sets[key].calculate_dom(min_range + sample * step_size), member_sets[key].get_dom())
			total_area += contribution
			sum_of_moments += (min_range + sample * step_size) * contribution
	
	if total_area == 0.0:
		return 0.0
	return sum_of_moments / total_area


func add_triangular_set(name: String, min_bound:float, peak:float, max_bound:float) -> FzSet:
	member_sets[name] = FuzzySetTriangle.new(peak, peak-min_bound, max_bound-peak)
	
	adjust_range_to_fit(min_bound, max_bound)
	
	return  FzSet.new(member_sets[name]) 


func add_right_shoulder_set(name:String, min_bound:float, peak:float, max_bound:float) -> FzSet:
	member_sets[name] = FuzzySetRightShoulder.new(peak, peak-min_bound, max_bound-peak)
	
	adjust_range_to_fit(min_bound, max_bound)
	
	return FzSet.new(member_sets[name]) 


func add_left_shoulder_set(name:String, min_bound:float, peak:float, max_bound:float) -> FzSet:
	member_sets[name] = FuzzySetLeftShoulder.new(peak, peak-min_bound, max_bound-peak)
	
	adjust_range_to_fit(min_bound, max_bound)
	
	return FzSet.new(member_sets[name]) 



func adjust_range_to_fit(min_bound:float, max_bound:float) -> void:
	if min_bound < min_range:
		min_range = min_bound
	if max_bound > max_range:
		max_range = max_bound
