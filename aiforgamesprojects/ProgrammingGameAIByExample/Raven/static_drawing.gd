extends Node2D



#func _draw() -> void:	# Draw the Grid rows and columns:
	#if DebugSettings.debug_mode:
		#for i in range(World.rows + 1):
			#var y = i * World.resolution
			#draw_line(Vector2(0, y), Vector2(World.width, y), Color.RED, 1.0)
		#
		#for c in range(World.columns + 1):
			#var x = c * World.resolution
			#draw_line(Vector2(x, 0), Vector2(x, World.height), Color.RED, 1.0)
