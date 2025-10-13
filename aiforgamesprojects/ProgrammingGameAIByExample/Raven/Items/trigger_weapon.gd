class_name WeaponTrigger
extends "res://ProgrammingGameAIByExample/Raven/Items/trigger_base.gd"

var weapon : RavenWeapon.WeaponType

func initialise(shape_x:float, shape_y:float,  _weapon: RavenNodeItem.ItemSubType) -> void:
	trigger_collision_shape.shape.size = Vector2(shape_x, shape_y)
	weapon = RavenNodeItemWeapon.enum_map_weapon.get(_weapon)

func _on_trigger_area_area_entered(area: Area2D) -> void:
	if is_active:
		var agent: RavenAgent = area.get_parent()
		agent.weapon_system.add_weapon(weapon)
