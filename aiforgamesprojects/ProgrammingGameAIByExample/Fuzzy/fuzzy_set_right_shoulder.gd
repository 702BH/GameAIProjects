class_name FuzzySetRightShoulder
extends "res://ProgrammingGameAIByExample/Fuzzy/fuzz_set.gd"

var peak_point : float
var left_offset : float
var right_offset: float

func _init(peak:float, left:float, right:float) -> void:
	# mid point of plateau
	super((peak + right) + peak / 2)
	peak_point = peak
	left_offset = left
	right_offset = right


func calculate_dom(val: float) -> float:
	# prevent divide by zero errors
	if (right_offset == 0.0 and peak_point == val) or (left_offset == 0 and peak_point == val):
		return 1.0
	
	# find DOM if left of center
	elif val <= peak_point and (val > (peak_point - left_offset)):
		var grad:float = 1.0/left_offset
		return grad * (val-(peak_point-left_offset))
	
	#find dom if right of center
	elif val > peak_point and val <= peak_point + right_offset:
		return 1.0
	
	return 0.0
