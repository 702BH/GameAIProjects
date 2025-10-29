class_name DebugData
extends RefCounted


enum Systems {BRAIN, STEERING, WEAPON, STATS, TARGETING}


var agent: RavenAgent
var system
var step
var messages : Array

static func build() -> DebugData:
	return DebugData.new()

func set_agent(_agent:RavenAgent) -> DebugData:
	agent = _agent
	return self

func set_system(sys :Systems) -> DebugData:
	system = sys
	return self

func add_message(ms: String) ->DebugData:
	messages.append(ms)
	return self

func set_step(s) -> DebugData:
	step = s
	return self
