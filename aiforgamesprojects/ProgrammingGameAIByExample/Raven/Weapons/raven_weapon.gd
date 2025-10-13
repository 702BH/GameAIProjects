class_name RavenWeapon
extends RefCounted

enum WeaponType {SHOTGUN, BLASTER, ROCKET_LAUNCHER, RAIL_GUN}

var owner_agent : RavenAgent
var weapon_type : WeaponType
var fuzzy_module : FuzzyModule
var num_rounds_left : int
var max_rounds_carried: int
var time_next_available : float
var rate_of_fire : float
var last_desirability_score:float
var ammo_to_add : int
var sound_range :float


static var projectiles_map = {
	WeaponType.SHOTGUN : 50.0,
	WeaponType.BLASTER : 50.0,
	WeaponType.ROCKET_LAUNCHER : 30.0,
	WeaponType.RAIL_GUN : 80.0
}


func _init(_agent: RavenAgent) -> void:
	owner_agent = _agent
	fuzzy_module = FuzzyModule.new()


func aim_at(target: Vector2) -> bool:
	return false

func shoot_at(pos: Vector2) -> void:
	pass

func get_desirability(dis_to_target:float) -> float:
	return 0.0

func initialise_fuzzy_module() -> void:
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
