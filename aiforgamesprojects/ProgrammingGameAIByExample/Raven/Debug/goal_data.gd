class_name GoalDataDebug
extends RefCounted


var name:String
var status: String
var children: Array[GoalDataDebug]
var extra_data: Dictionary

func _init(n:String, s:String, c: Array[GoalDataDebug], extra:Dictionary) -> void:
	name = n
	status = s
	children = c
	extra_data = extra
