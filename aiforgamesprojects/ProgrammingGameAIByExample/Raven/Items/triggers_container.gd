extends Node2D


#
#func _process(_delta: float) -> void:
	#check_triggers_status()

func check_triggers_status() -> void:
	var children = get_children()
	
	for child: Trigger in children:
		if !child.is_active:
			if Time.get_ticks_msec() - child.time_start_recovery > child.DURATION_RECOVERY:
				child.activate()
