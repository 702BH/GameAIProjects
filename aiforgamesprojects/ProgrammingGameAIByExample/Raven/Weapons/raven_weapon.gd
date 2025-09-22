class_name RavenWeapon
extends Node

enum WeaponType {SHOTGUN, BLASTER}

var owner_agent : RavenAgent
var weapon_type : WeaponType
var num_rounds_left : int
var max_rounds_carried: int

func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent


func aim_at(target: Vector2) -> bool:
	return false

func shoot_at(pos: Vector2) -> void:
	pass


func increment_rounds(num: int) -> void:
	num_rounds_left += num
	num_rounds_left = clamp(num_rounds_left, 0, max_rounds_carried)
