class_name HealthTrigger
extends "res://ProgrammingGameAIByExample/Raven/Items/trigger_base.gd"


func initialise(shape_x:float, shape_y:float) -> void:
	trigger_collision_shape.shape.size = Vector2(shape_x, shape_y)


func _on_trigger_area_area_entered(area: Area2D) -> void:
	if is_active:
		var agent: RavenAgent = area.get_parent()
		agent.add_health(10.0)
		deactivate()
