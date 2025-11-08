extends HBoxContainer

@onready var play_button := $Buttons/Play

func _on_play_pressed() -> void:
	play_button.disabled = true
	RavenServiceBus.game_start_requested.emit()
