class_name SystemsDebugger
extends Control



# systens
@onready var brain : TabDebugNode = $PanelContainer/Panels/TabContainer/Brain
@onready var memory : TabDebugNode = $PanelContainer/Panels/TabContainer/Memory
@onready var paths : TabDebugNode = $PanelContainer/Panels/TabContainer/Paths
@onready var steering :TabDebugNode = $PanelContainer/Panels/TabContainer/Steering
@onready var targeting :TabDebugNode = $PanelContainer/Panels/TabContainer/Targeting
@onready var weapons : TabDebugNode = $PanelContainer/Panels/TabContainer/Weapons

# key = service bus sytem Enum
var systems_dict : Dictionary

var selected_agent: RavenAgent


func _ready() -> void:
	RavenServiceBus.debug_event.connect(on_debug_event.bind())
	systems_dict = {
		DebugData.Systems.BRAIN : brain
	}

func on_debug_event(data: DebugData) -> void:
	if data != null:
		if systems_dict.has(data.system):
			var selected_system: TabDebugNode = systems_dict.get(data.system)
			if data.agent == selected_agent:
				selected_system.handle_debug_event(data)


func clear_systems() -> void:
	for key in systems_dict:
		systems_dict[key].clear_debug()
