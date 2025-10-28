class_name MapDrawing
extends Node2D


enum tool_state {NONE, WALL, SPAWNS, WEAPONS}
enum ui_state {MAP_EDITOR, MAP_RUNNING, MAP_SELECTIONS}


var mouse_in := true

var current_state: tool_state = tool_state.NONE
var current_ui_state: ui_state = ui_state.MAP_EDITOR


var selected_position

var dirty_nodes : Array = []

var draw_start :int
var draw_end: int

var font = ThemeDB.fallback_font



func _draw() -> void:
	#if !World.graph.nodes.is_empty():
		#for i in range(draw_start, draw_end):
			#var
	
	
	if !dirty_nodes.is_empty():
		for node:RavenNode in dirty_nodes:
			var neighbors : Array
			if node.node_type == RavenNode.NodeType.TRAVERSAL:
				draw_rect(Rect2(node.node_pos.x * World.resolution, node.node_pos.y * World.resolution, World.resolution, World.resolution), Color.WHITE)
				neighbors = World.graph.edges[node.id]
				if DebugSettings.debug_mode:
					if node.item_type:
						match node.item_type.item_type:
							RavenNodeItem.ItemType.HEALTH:
								#draw_string(font, World.grid_to_world(node.node_pos.x, node.node_pos.y), "H", HORIZONTAL_ALIGNMENT_CENTER, -1.0, 14, Color.RED)
								draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 5.0, Color.GREEN_YELLOW)
							RavenNodeItem.ItemType.WEAPON:
								if node.item_type.item_sub_type == RavenNodeItem.ItemSubType.SHOTGUN:
									#draw_string(font, World.grid_to_world(node.node_pos.x, node.node_pos.y)  + Vector2(-World.resolution, -5), "SHOTGUN", HORIZONTAL_ALIGNMENT_CENTER, -1.0, 10, Color.BLACK)
									draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 5.0, Color.CRIMSON)
								elif node.item_type.item_sub_type == RavenNodeItem.ItemSubType.ROCKET_LAUNCHER:
									draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 5.0, Color.AQUA)
								elif node.item_type.item_sub_type == RavenNodeItem.ItemSubType.BLASTER:
									draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 5.0, Color.BLUE_VIOLET)#
								elif node.item_type.item_sub_type == RavenNodeItem.ItemSubType.RAIL_GUN:
									draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 5.0, Color.CORAL)
			elif node.node_type == RavenNode.NodeType.SPAWN:
				draw_rect(Rect2(node.node_pos.x * World.resolution, node.node_pos.y * World.resolution, World.resolution, World.resolution), Color.WHITE)
				if DebugSettings.debug_mode:
					draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 4.0, Color.REBECCA_PURPLE)
				neighbors = World.graph.edges[node.id]
			else:
				# its a wall
				draw_rect(Rect2(node.node_pos.x * World.resolution, node.node_pos.y * World.resolution, World.resolution, World.resolution), Color.BLACK)
				neighbors = World.graph.edges[node.id]
				# we should "delete" the edge lines
				
			if !neighbors.is_empty():
				for neighbor: GraphEdge in neighbors:
					
					var node_row = neighbor.to / World.columns
					var node_col = neighbor.to % World.columns
					var current_neighbor: RavenNode = World.grid_world[node_row][node_col]
					if DebugSettings.debug_mode:
						if node.node_type == RavenNode.NodeType.WALL:
							draw_line(World.grid_to_world(node.node_pos.x, node.node_pos.y), World.grid_to_world(current_neighbor.node_pos.x, current_neighbor.node_pos.y), Color.WHITE)
						
						else:
							draw_line(World.grid_to_world(node.node_pos.x, node.node_pos.y), World.grid_to_world(current_neighbor.node_pos.x, current_neighbor.node_pos.y), Color.WEB_GREEN)
			if node.node_type == RavenNode.NodeType.WALL:
				World.graph.remove_wall(node.id)
		dirty_nodes.clear()
	#if !World.graph.nodes.is_empty():
		#for node:RavenNode in World.graph.nodes:
			#var neighbors : Array
			#if node.node_type == RavenNode.NodeType.TRAVERSAL:
				#draw_rect(Rect2(node.node_pos.x * World.resolution, node.node_pos.y * World.resolution, World.resolution, World.resolution), Color.WHITE)
				#neighbors = World.graph.edges[node.id]
				#if node.item_type:
					#if node.item_type.item_type == RavenNodeItem.ItemType.WEAPON:
						#draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 6.0, Color.CRIMSON)
			#elif node.node_type == RavenNode.NodeType.SPAWN:
				#draw_rect(Rect2(node.node_pos.x * World.resolution, node.node_pos.y * World.resolution, World.resolution, World.resolution), Color.WHITE)
				#draw_circle(World.grid_to_world(node.node_pos.x, node.node_pos.y), 4.0, Color.REBECCA_PURPLE)
				#neighbors = World.graph.edges[node.id]
			#else:
				#draw_rect(Rect2(node.node_pos.x * World.resolution, node.node_pos.y * World.resolution, World.resolution, World.resolution), Color.BLACK)
	#
			#if !neighbors.is_empty():
				#for neighbor: GraphEdge in neighbors:
					#
					#var node_row = neighbor.to / World.columns
					#var node_col = neighbor.to % World.columns
					#var current_neighbor: RavenNode = World.grid_world[node_row][node_col]
					#draw_line(World.grid_to_world(node.node_pos.x, node.node_pos.y), World.grid_to_world(current_neighbor.node_pos.x, current_neighbor.node_pos.y), Color.WEB_GREEN)
	#if !dirty_nodes.is_empty():
		#print("NOT EMPTY")
