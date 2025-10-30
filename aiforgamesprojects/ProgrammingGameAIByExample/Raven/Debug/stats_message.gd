class_name StatsDataDebug
extends RefCounted


var name : String
var health: String
var goal: String
var weapon: String
var target: String

func _init(n:String, h:String, g:String, w:String, t:String) -> void:
	name = n
	health = h
	goal = g
	weapon = w
	target = t
