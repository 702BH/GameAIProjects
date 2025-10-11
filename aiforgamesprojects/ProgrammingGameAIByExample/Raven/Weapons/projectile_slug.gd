class_name ProjectileSlug
extends "res://ProgrammingGameAIByExample/Raven/Weapons/raven_projectile.gd"


func _init(_target: Vector2) -> void:
	super(_target)
	damage_inflicted = 1.0
	max_speed = 80.0
	max_force = 200.0
	radius = 3.0



func _physics_process(delta: float) -> void:
	velocity = max_speed * heading
	
	position += velocity * delta
	#print(position)
	_agent_collision()
	if _out_of_world():
		#print("SHOULD DIE")
		queue_free()
	
	if projectile_regulator.is_ready():
		if _wall_collision():
			#print("AHHHHHH")
			queue_free()


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var font = ThemeDB.fallback_font
	draw_string(font, Vector2(0, 15), "RAILGUN", HORIZONTAL_ALIGNMENT_CENTER, -1.0, 16, Color.BLACK)
	draw_circle(Vector2.ZERO, radius, Color.CORAL)
