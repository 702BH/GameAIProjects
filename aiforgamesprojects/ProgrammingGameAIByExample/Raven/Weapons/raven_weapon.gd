class_name RavenWeapon
extends Node

enum WeaponType {SHOTGUN, BLASTER}

var owner_agent : RavenAgent
var weapon_type : WeaponType
var num_rounds_left : int
var max_rounds_carried: int
var time_next_available : float
var rate_of_fire : float

func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent


func aim_at(target: Vector2) -> bool:
	return false

func shoot_at(pos: Vector2) -> void:
	pass


func increment_rounds(num: int) -> void:
	num_rounds_left += num
	num_rounds_left = clamp(num_rounds_left, 0, max_rounds_carried)


func is_ready_for_next_shot() -> bool:
	if Time.get_ticks_msec() / 1000.0 > time_next_available:
		return true
	return false


func update_time_weapon_is_next_available() -> void:
	time_next_available = Time.get_ticks_msec()/1000.0 + 1.0 / rate_of_fire
