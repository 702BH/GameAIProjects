class_name FuzzyOperators
extends "res://ProgrammingGameAIByExample/Fuzzy/fuzzy_term.gd"

var terms : Array[FuzzyTerm]

func _init(ops : Array[FuzzyTerm]) -> void:
	if !ops.is_empty():
		terms.append(ops.duplicate(true))
