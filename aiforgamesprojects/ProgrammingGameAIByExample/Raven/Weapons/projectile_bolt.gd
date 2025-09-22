class_name ProjectileBolt
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_projectile.gd"


func _init(_target: Vector2) -> void:
	super(_target)
	damage_inflicted = 1.0
	max_speed = 7.0
	max_force = 5.0



func _physics_process(delta: float) -> void:
	velocity = max_speed * (target - position)
	
	position += velocity


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 7.0, Color.ORANGE_RED)
