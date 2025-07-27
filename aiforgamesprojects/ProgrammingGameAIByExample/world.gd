extends Node2D


#var target := Vector2.ZERO
var selected_text := "SEEK"
var selected_deceleration := "SLOW"

var selected_target_state := "STATIC"

@onready var vechile : Vehicle = $Vehicle
@onready var target : Target = $Target

func _ready() -> void:
	target.position = Vector2(randi_range(0, get_window().size.x), randi_range(0, get_window().size.y))
	target.vehicle = vechile
	vechile.target = target
	vechile.deceleration_factor = vechile.Deceleration.get(selected_deceleration)
	vechile.switch_state(vechile.State.ARRIVE)
	target.switch_state(Target.State.STATIC)

func _process(delta: float) -> void:
	if vechile.current_state is SteeringArrive:
		$UI/HBoxContainer/VBoxContainer/DecelerationFactor.visible = true
	else:
		$UI/HBoxContainer/VBoxContainer/DecelerationFactor.visible = false

func _physics_process(delta: float) -> void:
	$UI/HBoxContainer/VBoxContainer/Velocity.text = "Velocity: " + str(snapped(vechile.velocity.length(), 0.01))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			target.position = get_global_mouse_position()
			target.switch_state(Target.State.PURSUED)
			vechile.target = target
			vechile.switch_state(vechile.State.get(selected_text))
	


func _on_option_button_item_selected(index: int) -> void:
	var selected = $UI/HBoxContainer/VBoxContainer/OptionButton.selected
	selected_text = $UI/HBoxContainer/VBoxContainer/OptionButton.get_item_text(selected)
	vechile.switch_state(vechile.State.get(selected_text))


func _on_deceleration_factor_item_selected(index: int) -> void:
	var selected = $UI/HBoxContainer/VBoxContainer/DecelerationFactor.selected
	selected_deceleration = $UI/HBoxContainer/VBoxContainer/DecelerationFactor.get_item_text(selected)
	vechile.deceleration_factor = vechile.Deceleration.get(selected_deceleration)
	vechile.switch_state(vechile.State.ARRIVE)


func _on_target_state_item_selected(index: int) -> void:
	var selected = $UI/HBoxContainer/TargetControls/TargetState.selected
	selected_target_state = $UI/HBoxContainer/TargetControls/TargetState.get_item_text(selected)
	target.switch_state(Target.State.get(selected_target_state))
