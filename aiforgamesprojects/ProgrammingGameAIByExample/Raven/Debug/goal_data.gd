class_name GoalDataDebug
extends RefCounted


var name:String
var status: String
var children: Array[GoalDataDebug]
var tool_tip_text: String
var extra_data: Dictionary
var color: Color

func _init(n:String, s:String, c: Array[GoalDataDebug], extra:Dictionary,  col:Color, tool_text:String) -> void:
	name = n
	status = s
	children = c
	extra_data = extra
	color = col
	tool_tip_text = tool_text
