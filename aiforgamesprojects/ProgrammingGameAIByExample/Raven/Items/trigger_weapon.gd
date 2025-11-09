class_name WeaponTrigger
extends "res://ProgrammingGameAIByExample/Raven/Items/trigger_base.gd"

var weapon : RavenWeapon.WeaponType

var weapon_sprite_map = {
	RavenWeapon.WeaponType.ROCKET_LAUNCHER : preload("res://ProgrammingGameAIByExample/Raven/Assets/tile_0014.png"),
	RavenWeapon.WeaponType.RAIL_GUN : preload("res://ProgrammingGameAIByExample/Raven/Assets/tile_0003.png"),
	RavenWeapon.WeaponType.SHOTGUN : preload("res://ProgrammingGameAIByExample/Raven/Assets/tile_0007.png"),
}

func initialise(shape_x:float, shape_y:float,  _weapon: RavenNodeItem.ItemSubType) -> void:
	trigger_collision_shape.shape.size = Vector2(shape_x, shape_y)
	weapon = RavenNodeItemWeapon.enum_map_weapon.get(_weapon)
	$Sprite2D.texture = weapon_sprite_map[weapon]

func _on_trigger_area_area_entered(area: Area2D) -> void:
	if is_active:
		var agent: RavenAgent = area.get_parent()
		agent.weapon_system.add_weapon(weapon)
