class_name Sheep
extends MoverBase

enum State {EATING, SEEKING, FLEEING, SLEEPING}

var world
var flock : Array[Sheep] = []
var resolution := 1.0
var cols
var rows

var current_state : SheepState = null
var state_factory := SheepStateFactory.new()
var steering_controller := SheepSteeringController.new(self)

var hunger := 50.0
var max_hunger := 100.0
#var hunger_depletion_rate := 1.0



func _ready() -> void:
	
	switch_state(State.EATING)


func _physics_process(delta: float) -> void:
	#hunger = max(hunger - hunger_depletion_rate * delta, 0)
	var steering_force = steering_controller.calculate()
	apply_force(steering_force)
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta
	acceleration = Vector2.ZERO
	wrap_around()
	rotateVehicle(delta)
	

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var points = PackedVector2Array([Vector2(-radius, -radius), Vector2(radius, 0), Vector2(-radius, radius)])
	var colors = PackedColorArray([color.to_rgba64(), color.to_rgba64(), color.to_rgba64()])
	draw_primitive(points, colors, [])

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, steering_controller)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "SteeringStateMachine: " + str(state)
	call_deferred("add_child", current_state)
	$State/Label.text = State.keys()[state]


func position_to_grid(pos: Vector2) -> Vector2:
	var col = clamp(int(pos.x / resolution), 0, cols - 1)
	var row = clamp(int(pos.y / resolution) , 0 , rows - 1)
	return Vector2(col, row)
