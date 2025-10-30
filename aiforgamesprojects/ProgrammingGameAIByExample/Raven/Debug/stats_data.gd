class_name StatsData
extends "res://ProgrammingGameAIByExample/Raven/Debug/debug_data_base.gd"

enum Steps {HEALTH, GOAL, WEAPON_SELECTION, TARGET_SELECTION}


static func build() -> StatsData:
	return StatsData.new()

func add_message_stats(ms: StatsDataDebug) ->StatsData:
	messages.append(ms)
	return self
