class_name Vehicle
extends Mover

const PANIC_DISTANCE := 50.0


enum State {SEEK, FLEE, ARRIVE, PURSUE, WANDER, OBSTACLE_AVOIDANCE}
enum Deceleration {FAST = 1, NORMAL = 2, SLOW = 3}


var target : Target = null 


var current_state : SteeringState = null
var state_factory := SteeringStateFactory.new()
var deceleration_factor := 0

var obstacles : Array[Obstacle] = []


#func _ready() -> void:
	#switch_state(State.SEEK)


func _physics_process(delta: float) -> void:
	detection_box_length = min_detection_box_length + (velocity.length() / max_speed) * min_detection_box_length
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta
	acceleration = Vector2.ZERO
	wrap_around()
	rotateVehicle(delta)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, target, obstacles)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "SteeringStateMachine: " + str(state)
	call_deferred("add_child", current_state)
	$State/Label.text = State.keys()[state]
