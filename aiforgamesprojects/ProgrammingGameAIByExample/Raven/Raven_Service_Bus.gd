class_name RavenEventBus
extends Node


var selected_node: RavenNode = null

signal mode_changed(mode: MapDrawing.tool_state)
signal weapon_popup()
signal submitted_weapon(weapon: RavenNodeItemWeapon.WeaponSubtype)

signal fire_projectile(bullet: RavenProjectile)
