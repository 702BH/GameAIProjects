extends Node2D

const MAX_SPEED := 5.0
const MAX_FORCE := 10.0
const TIME_TO_TARGET := 0.25
const RADIUS := 30

@onready var seeker := $Seeker
@onready var target := $Target

var behaviour := 0

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

var behaviours := {
	0: Callable(self, "seek"),
	1: Callable(self, "flee"),
	2: Callable(self, "SeekArrive")
}

func _ready() -> void:
	place_bodies()


func _process(delta: float) -> void:
	$Target.position += Vector2(randf_range(-3,3), randf_range(-3,3))
	var selectedBehaviour: Callable = behaviours.get(behaviour, null)
	
	if selectedBehaviour:
		var steeringForce = selectedBehaviour.call(seeker, target) * delta
		seeker.position += velocity
		velocity += steeringForce
	#if behaviour == 0:
		#seeker.position += seek(seeker, target) * delta
	#elif behaviour == 1:
		#seeker.position += flee(seeker, target) * delta
	#if check_arrived(seeker, target):
		#get_tree().reload_current_scene()


func place_bodies() -> void:
	var children  = get_children()
	for i in children:
		i.position = Vector2(randf_range(0, 1000), randf_range(100, 600))


func seek(seeker : Sprite2D, target: Sprite2D) -> Vector2:
	var direction = target.position - seeker.position
	direction = direction.normalized()
	direction *= MAX_SPEED
	return direction


func check_arrived(seeker : Sprite2D, target: Sprite2D) -> bool:
	var distance = seeker.position.distance_to(target.position)
	return distance < 10


func flee(seeker : Sprite2D, target: Sprite2D) -> Vector2:
	var direction = target.position - seeker.position
	direction *= -1
	direction = direction.normalized()
	direction *= MAX_SPEED
	return direction


func _on_option_button_item_selected(index: int) -> void:
	velocity = Vector2.ZERO
	behaviour = index

func SeekArrive(seeker : Sprite2D, target: Sprite2D) -> Vector2:
	var direction = target.position - seeker.position
	if direction.length() < RADIUS:
		return Vector2.ZERO
	
	direction = direction / TIME_TO_TARGET
	if direction.length() > MAX_SPEED:
		direction = direction.normalized()
		direction *= MAX_SPEED
	
	return direction
