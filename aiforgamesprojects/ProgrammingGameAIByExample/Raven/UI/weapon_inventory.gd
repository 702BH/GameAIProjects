class_name WeaponInventory
extends Control


@onready var wep := $HBoxContainer/Weapon
@onready var amm := $HBoxContainer/Ammo


func initialise() -> void:
	pass


func update_weapon_info(weapon_name:String, ammo:int) -> void:
	wep.text = weapon_name
	amm.text = str(ammo)
