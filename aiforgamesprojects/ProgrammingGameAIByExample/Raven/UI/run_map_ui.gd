class_name PlayModeUI
extends HBoxContainer


var steps_dict = {
	BrainData.Steps.keys()[BrainData.Steps.GOALS] : Callable(display_goal_data),
	WeaponData.Steps.keys()[WeaponData.Steps.WEAPON_SELECTION]  : Callable(display_weapon),
	StatsData.Steps.HEALTH : Callable(display_health)
}


func _ready() -> void:
	RavenServiceBus.debug_event.connect(on_debug_event.bind())

func on_debug_event(data: DebugData) -> void:
	if data != null:
		pass


func display_goal_data() -> void:
	pass

func display_weapon() -> void:
	pass

func display_health() -> void:
	pass
