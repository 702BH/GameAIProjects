extends HBoxContainer

@onready var play_button := $Buttons/Play
@onready var possess_button := $Buttons/Possess

@onready var selected_label := $Info/Selected
@onready var health_label := $Info/Health
@onready var goal_label := $Info/Goal
@onready var weapon_label := $Info/Weapon
@onready var target_label := $Info/Target

var possessed_agent: RavenAgent
var selected_agent: RavenAgent

var selected_base_text := "Agent Selected: "
var health_base_text := "Health: "
var goal_base_text := "Goal: "
var weapon_base_text := "Weapon: "
var target_base_text := "Target: "

var debug_regulator = Regulator.new(2.0)


func _ready() -> void:
	RavenServiceBus.agent_possessed.connect(_on_agent_possessed.bind())
	RavenServiceBus.agent_selected.connect(_on_agent_selected.bind())
	RavenServiceBus.agent_delesected.connect(_on_agent_deselected.bind())


func _process(_delta: float) -> void:
	if debug_regulator.is_ready():
		if selected_agent:
			selected_label.text = selected_base_text + selected_agent.get_agent_name()
			health_label.text = health_base_text + selected_agent.get_health()
			goal_label.text = goal_base_text + selected_agent.get_current_goal()
			weapon_label.text = weapon_base_text + selected_agent.get_current_weapon()
			target_label.text = target_base_text + selected_agent.get_current_target()

func _on_play_pressed() -> void:
	play_button.disabled = true
	RavenServiceBus.game_start_requested.emit()


func _on_possess_pressed() -> void:
	RavenServiceBus.agent_possess_requested.emit()


func _on_agent_possessed(agent: RavenAgent) -> void:
	possessed_agent = agent 

func _on_agent_selected(agent: RavenAgent) -> void:
	selected_agent = agent
	possess_button.disabled = false

func _on_agent_deselected() -> void:
	selected_agent = null
	possess_button.disabled = true
	selected_label.text = selected_base_text + "None"
	health_label.text = health_base_text + "None"
	goal_label.text = goal_base_text + "None"
	weapon_label.text = weapon_base_text + "None"
	target_label.text = target_base_text + "None"
