class_name PlayModeUI
extends HBoxContainer


@onready var goal_text := $HBoxContainer/Goal/CurrentGoal
@onready var agent_name_text := $HBoxContainer/AgentUI/selectedName
@onready var agent_health_text := $HBoxContainer/Health/Amount
@onready var weapon_text := $HBoxContainer/Weapon/Weapon
@onready var target_text := $HBoxContainer/Target/Target


var steps_dict = {
	DebugData.Systems.STATS : Callable(update_debug_data)
}

var selected_agent

func _ready() -> void:
	RavenServiceBus.debug_event.connect(on_debug_event.bind())

func on_debug_event(data: DebugData) -> void:
	#print("debug event")
	if data != null:
		if steps_dict.has(data.system):
			if data.agent == selected_agent:
				steps_dict[data.system].call(data.messages[0])


func update_debug_data(data: StatsDataDebug) -> void:
	agent_name_text.text = data.name
	display_goal_data(data.goal)
	display_weapon(data.weapon)
	display_health(data.health)
	display_target(data.target)

func display_goal_data(goal : String) -> void:
	goal_text.text = goal

func display_weapon(weapon : String) -> void:
	weapon_text.text = weapon

func display_health(health : String) -> void:
	agent_health_text.text = health

func display_target(target: String) -> void:
	target_text.text = target


func clear_ui() -> void:
	agent_name_text.text = "None"
	goal_text.text = ""
	weapon_text.text = ""
	agent_health_text.text = ""
	target_text.text = ""


func _on_play_pressed() -> void:
	#print("Possess Requested")
	RavenServiceBus.agent_possess_requested.emit()
