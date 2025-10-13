class_name Trigger
extends Node2D

const DURATION_RECOVERY := 500
var is_active := true

@onready var trigger_collision_shape : CollisionShape2D= $triggerArea/triggerAreaCollision

var time_start_recovery

func deactivate() -> void:
	is_active = false
	time_start_recovery = Time.get_ticks_msec()
	print("TRIGGER DEACTIVATED")


func activate() -> void:
	is_active = true
	print("TRIGGER ACTIVE")
