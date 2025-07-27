class_name  TargetStatic
extends TargetState


func _enter_tree() -> void:
	print("STATIC")
	vehicle.velocity = Vector2.ZERO
