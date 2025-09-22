class_name RavenWeapon
extends Node

enum WeaponType {SHOTGUN}

var owner_agent : RavenAgent

func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent


func aim_at(target: Vector2) -> bool:
	return false

func shoot_at(pos: Vector2) -> void:
	pass
