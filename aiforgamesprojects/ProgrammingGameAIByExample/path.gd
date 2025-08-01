class_name PathI

var points : Array[Vector2] = []

var is_closed := false

var current_index :=0

func get_next_way_point() -> Vector2:
	if points.is_empty():
		return Vector2.ZERO
	
	if current_index >= points.size():
		if is_closed:
			current_index = 0
		else:
			return Vector2.ZERO
	var point = points[current_index]
	current_index +=1
	return point

func is_finished() -> bool:
	return current_index >= points.size()
