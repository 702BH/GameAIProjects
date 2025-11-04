class_name SoundTrigger
extends "res://ProgrammingGameAIByExample/Raven/Items/trigger_base.gd"

var fired_by : RavenAgent

func initialise(shape_x:float, shape_y:float, agent: RavenAgent) -> void:
	trigger_collision_shape.shape.size = Vector2(shape_x, shape_y)
	time_start_recovery = Time.get_ticks_msec()
	fired_by = agent

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_recovery > DURATION_RECOVERY:
		queue_free()

func _on_trigger_area_area_entered(area: Area2D) -> void:
	if fired_by:
		if is_active:
			var agent: RavenAgent = area.get_parent()
			agent.sensory_memory.update_with_sound_source(fired_by)
