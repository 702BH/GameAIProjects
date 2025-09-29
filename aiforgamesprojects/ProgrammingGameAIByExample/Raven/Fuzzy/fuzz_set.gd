class_name FuzzySet
extends RefCounted


var dom : float =0.0

# maximum of the sets membership function
var representative_value : float

func _init(rep_val) -> void:
	representative_value = rep_val


func calculate_dom(val: float) -> float:
	
	return 0.0

func or_with_dom(val: float) -> void:
	if val > dom:
		dom = val


# Accessor methods
func get_representative_value() -> float:
	return representative_value

func clear_dom() -> void:
	dom = 0.0

func get_dom() -> float:
	return dom

func set_dom(val: float) -> void:
	assert((val <= 1) && (val >=0), "Invalid value")
	dom = val
