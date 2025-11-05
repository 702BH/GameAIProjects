extends Node2D

@export var buttons : PackedScene
@export var width := 1152.0
@export var height := 600.0

@onready var ui_base:= $UI/UIBase
@onready var world_sprite := $WorldSprite
@onready var map_input := $MapDrawingInput

var resolution := 24.0
var loaded_map := ""
# grid-space partioning
var cell_size = 4


func _ready() -> void:
	var buttons :HBoxContainer = buttons.instantiate()
	ui_base.add_buttons(buttons)
	
	# initialise the map drawing input
	map_input.setup_viewport(width, height)
	
	
	# initialise the world and generate the grid
	World.initialise(width, height, resolution, cell_size)
	World.graph = RavenGraph.new(false)
	World.generate_grid()
	
