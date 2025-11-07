extends Node2D

@export var buttons : PackedScene
@export var width := 1152.0
@export var height := 600.0


@onready var ui_base:= $UI/UIBase
@onready var world_sprite := $WorldSprite
@onready var map_input := $MapDrawingInput
@onready var map_popup := $MapSelection

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
	
	# signals
	RavenServiceBus.load_map_pressed.connect(_on_load_map_pressed.bind())
	RavenServiceBus.map_selected.connect(_on_map_selected.bind())
	RavenServiceBus.map_save_request.connect(_on_map_save_request.bind())

func _on_map_selected(file_path:String) -> void:
	World.load_world_from_file(file_path)

func _on_load_map_pressed() -> void:
	map_popup.root_subfolder = "res://ProgrammingGameAIByExample/Raven/Maps/"
	map_popup.popup_centered()


func _on_map_selection_file_selected(path: String) -> void:
	RavenServiceBus.map_selected.emit(path)
	map_popup.hide()


func _on_map_save_request(name:String) -> void:
	World.save_map(name)
