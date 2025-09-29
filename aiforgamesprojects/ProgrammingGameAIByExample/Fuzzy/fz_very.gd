class_name FzVery
extends "res://ProgrammingGameAIByExample/Fuzzy/fuzzy_term.gd"

var ref_set : FuzzySet

func _init(fz: FzSet) -> void:
	ref_set = fz.set_ref



func get_dom() -> float:
	return ref_set.get_dom() * ref_set.get_dom()


func clear_dom() -> void:
	ref_set.clear_dom()


func or_with_dom(val:float) -> void:
	ref_set.or_with_dom(val * val)
