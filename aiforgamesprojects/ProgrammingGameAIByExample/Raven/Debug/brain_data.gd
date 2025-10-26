class_name BrainData
extends "res://ProgrammingGameAIByExample/Raven/Debug/debug_data_base.gd"

enum Steps {ARBITRATION, GOALS}


static func build() -> BrainData:
	return BrainData.new()

func add_message_goals(ms: GoalDataDebug) ->DebugData:
	messages.append(ms)
	return self
