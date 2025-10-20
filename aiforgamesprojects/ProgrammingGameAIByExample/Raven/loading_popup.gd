extends Panel


func _ready() -> void:
	RavenServiceBus.load_pop_up.connect(_on_load_start.bind())

func _on_load_start() -> void:
	visible = !visible
	$VBoxContainer/animation.loading = !$VBoxContainer/animation.loading
