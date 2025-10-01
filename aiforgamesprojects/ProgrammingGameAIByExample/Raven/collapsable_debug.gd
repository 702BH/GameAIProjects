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
var systems_dict = {
	RavenServiceBus.System.BRAIN : brain
}


func _ready() -> void:
	RavenServiceBus.debug_event.connect(on_debug_event.bind())


func on_debug_event(system: RavenServiceBus.System, event: Dictionary) -> void:
	var selected_system: TabDebugNode = systems_dict.get(system)
	if selected_system:
		selected_system.handle_debug_event(event)
