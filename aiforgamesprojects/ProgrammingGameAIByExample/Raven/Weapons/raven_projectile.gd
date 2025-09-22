class_name RavenProjectile
extends RavenMover

var target : Vector2
var damage_inflicted : float


func _init(_target: Vector2) -> void:
	target = _target
