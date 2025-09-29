class_name FzSet
extends "res://ProgrammingGameAIByExample/Raven/Fuzzy/fuzzy_term.gd"


var set_ref : FuzzySet

func _init(_set: FuzzySet) -> void:
	set_ref = _set

func get_dom() -> float:
	return set_ref.get_dom()


func clear_dom() -> void:
	set_ref.clear_dom()


func or_with_dom(val:float) -> void:
	set_ref.or_with_dom(val)
