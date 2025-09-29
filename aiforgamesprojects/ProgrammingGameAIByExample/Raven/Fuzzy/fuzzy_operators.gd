class_name FuzzyOperators
extends "res://ProgrammingGameAIByExample/Raven/Fuzzy/fuzzy_term.gd"

var terms : Array[FuzzyTerm]

func _init(ops : Array[FuzzyTerm]) -> void:
	if !ops.is_empty():
		terms = ops.duplicate(true)
