class_name FuzzyOr
extends "res://ProgrammingGameAIByExample/Fuzzy/fuzzy_operators.gd"

func get_dom() -> float:
	
	var largest : float = -INF
	
	for term in terms:
		if term.get_dom() > largest:
			largest = term.get_dom()
	
	return largest

func clear_dom() -> void:
	for term in terms:
		term.clear_dom()


func or_with_dom(val:float) -> void:
	for term in terms:
		term.or_with_dom(val)
