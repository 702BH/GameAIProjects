class_name MinHeap
extends RefCounted

var data: Array = []

func push(value:int, priority:int):
	data.append({"val": value, "prio":priority})
	_bubble_up(data.size() - 1)

func pop() -> int:
	if data.size() == 0:
		return -1
	var root = data[0]
	if data.size() == 1:
		data.clear()
	else:
		data[0] = data.pop_back()
		_bubble_down(0)
	return root["val"]

func _bubble_up(index:int) -> void:
	var element = data[index]
	while index > 0:
		var parent_index = _parent_index(index)
		var parent = data[parent_index]
		if _has_lower_prio(element, parent):
			data[index] = parent
			index = parent_index
		else:
			break
	data[index] = element


func _bubble_down(index: int) -> void:
	var element = data[index]
	var current_index = index
	while true:
		var child_index = _highest_priority_child_index(current_index)
		if child_index == -1:
			break
		if _has_lower_prio(data[child_index], element):
			data[current_index] = data[child_index]
			current_index = child_index
		else:
			break
	data[current_index] = element


func _has_lower_prio(element_1, element_2) -> bool:
	return element_1["prio"] < element_2["prio"]


func _has_higher_prio(element_1, element_2) -> bool:
	return element_1["prio"] > element_2["prio"]


func _left_child_index(index) -> int:
	return index * 2 + 1

func _parent_index(index:int) -> int:
	return int((index-1) / 2)


func _highest_priority_child_index(index) -> int:
	var first_index = _left_child_index(index)
	if first_index >= data.size():
		return -1
	if first_index + 1 >= data.size():
		return first_index
	if _has_lower_prio(data[first_index], data[first_index + 1]):
		return first_index
	else: 
		return first_index + 1
