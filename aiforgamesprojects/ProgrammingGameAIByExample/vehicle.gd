class_name Vehicle
extends Mover

const PANIC_DISTANCE := 50.0


enum State {SEEK, FLEE, ARRIVE, PURSUE, WANDER, OBSTACLE_AVOIDANCE, WALL_AVOIDANCE, INTERPOSE}



var target : Target = null 


var current_state : SteeringState = null
var state_factory := SteeringStateFactory.new()
var deceleration_factor := 0

var obstacles : Array[Obstacle] = []
@onready var area : Area2D = $Area2D
@onready var feeler : RayCast2D = $RayCast2D

var interpose_target_1: Vehicle = null
var interpose_target_2: Vehicle = null


func _physics_process(delta: float) -> void:
	detection_box_length = min_detection_box_length + (velocity.length() / max_speed) * min_detection_box_length
	$Area2D/CollisionShape2D.shape.points = pointsDetector
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta
	acceleration = Vector2.ZERO
	wrap_around()
	rotateVehicle(delta)

func switch_state(state: State, state_data: SteeringStateData = SteeringStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, target, obstacles, state_data, interpose_target_1, interpose_target_2)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "SteeringStateMachine: " + str(state)
	call_deferred("add_child", current_state)
	$State/Label.text = State.keys()[state]
