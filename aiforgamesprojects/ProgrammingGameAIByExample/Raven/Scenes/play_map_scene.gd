extends Node2D


@onready var world_sprite := $WorldSprite

func _ready() -> void:
	if World.current_texture:
		world_sprite.texture = World.current_texture
	else:
		
		print("PLAY MAP SHOULD BE LOADED")
		if World.current_map_name:
			print("HAS MAP")
			print(World.current_map_name)
			var file_name: String = World.current_map_name
			file_name = file_name.get_slice(".", 0)
			print(file_name)
			var loaded_img := load("res://ProgrammingGameAIByExample/Raven/Maps/Images/" + file_name + ".png")
			world_sprite.texture = loaded_img
		else:
			print("NO MAP")
	
