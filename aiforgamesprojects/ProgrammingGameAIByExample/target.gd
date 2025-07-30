class_name Target
extends Mover

enum State {STATIC, PURSUED, FLEEING, EVADE, HIDE}

const PANIC_DISTANCE := 100.0
const SAFE_DISTANCE := 200.0

var vehicle : Vehicle = null

var current_state : TargetState = null
var state_factory := TargetStateFactory.new()

var obstacles : Array[Obstacle] = []

func _physics_process(delta: float) -> void:
	velocity += acceleration * delta
	position += velocity * delta
	acceleration = Vector2.ZERO
	wrap_around()
	rotateVehicle(delta)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, vehicle, obstacles)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "SteeringStateMachine: " + str(state)
	call_deferred("add_child", current_state)
	$State/Label.text = State.keys()[state]
