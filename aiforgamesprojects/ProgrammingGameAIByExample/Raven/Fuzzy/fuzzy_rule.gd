class_name FuzzyRule
extends RefCounted


var antecdent: FuzzyTerm
var consequence: FuzzyTerm

func _init(ant: FuzzyTerm, con: FuzzyTerm) -> void:
	antecdent = ant
	consequence = con



func set_confidences_of_consequents_zero() -> void:
	consequence.clear_dom()


func calculate() -> void:
	consequence.or_with_dom(antecdent.get_dom())
