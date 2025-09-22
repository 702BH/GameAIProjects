class_name RavenWeaponSystem
extends Node


var owner_agent : RavenAgent
var current_weapon: RavenWeapon
var reaction_time : float
var aim_accuracy : float

# key = WeaponType enum, value = pointer to weapon carrying
var weapon_map : Dictionary = {}


func _init(_agent: RavenAgent, _react_time: float, _acc: float) -> void:
	owner_agent = _agent
	reaction_time = _react_time
	aim_accuracy = _acc
	current_weapon = WeaponBlaster.new(owner_agent)
	
	weapon_map.clear()
	
	weapon_map[RavenWeapon.WeaponType.BLASTER] = current_weapon


func predict_future_position_of_target() -> Vector2:
	return Vector2.ZERO

func add_noise_to_aim(aiming_pos: Vector2) -> void:
	pass

func take_aim_and_shoot() -> void:
	pass

func select_weapon() -> void:
	current_weapon = weapon_map[RavenWeapon.WeaponType.BLASTER]

func add_weapon(weapon_type: RavenWeapon.WeaponType) -> void:
	
	var w: RavenWeapon
	
	match weapon_type:
		RavenWeapon.WeaponType.SHOTGUN:
			w = WeaponShotgun.new(owner_agent)
		RavenWeapon.WeaponType.BLASTER:
			w = WeaponBlaster.new(owner_agent)
	
	
	var present: RavenWeapon = weapon_map.get( w.weapon_type)
	
	if present:
		# add ammo
		present.increment_rounds(w.num_rounds_left)
	else:
		weapon_map[w.weapon_type] = w


func change_weapon(weapon_type: RavenWeapon.WeaponType) -> void:
	var w = weapon_map.get(weapon_type, null)
	if w:
		current_weapon = w


func get_current_weapon() -> RavenWeapon:
	return current_weapon


func get_weapon_from_inventory(weapon: RavenWeapon.WeaponType) -> RavenWeapon:
	return weapon_map.get(weapon, null)
