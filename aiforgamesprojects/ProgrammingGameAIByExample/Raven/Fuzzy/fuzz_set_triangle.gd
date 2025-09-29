class_name FuzzySetTriangle
extends "res://ProgrammingGameAIByExample/Raven/Fuzzy/fuzz_set.gd"

var peak_point: float
var left_offset:float
var right_offset:float


func _init(mid:float, left:float, right:float) -> void:
	super(mid)
	peak_point = mid
	left_offset = left
	right_offset = right


func calculate_dom(val: float) -> float:
	print("Calculating DOM for triangle set")
	# prevent divide by zero errors
	if (right_offset == 0.0 and peak_point == val) or (left_offset == 0 and peak_point == val):
		return 1.0
	
	# left slope
	if val <= peak_point and val >= (peak_point-left_offset):
		var grad:float = 1.0/ left_offset
		print("LEFT SLOPE")
		print(grad * (val - (peak_point-left_offset)))
		return grad * (val - (peak_point-left_offset))
	
	# right slope
	elif val > peak_point and val < (peak_point + right_offset):
		var grad:float = 1.0 / -right_offset
		print("RIGHT SLOPE")
		print(grad * (val - peak_point) + 1.0)
		return grad * (val - peak_point) + 1.0
	
	else:
		print("SOMETGHING VERY WRONG HERE")
		return 0.0
