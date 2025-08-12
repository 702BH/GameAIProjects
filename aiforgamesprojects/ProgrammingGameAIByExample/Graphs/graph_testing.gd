extends Node2D


var graph: SparseGraph

@onready var graph_tree: Tree = $Control/HBoxContainer/VBoxContainer/GraphTree
@onready var add_node_button = $Control/HBoxContainer/VBoxContainer/Button
@onready var node_label : Label = $Control/HBoxContainer/NodeManipulation/Label

func _ready() -> void:
	graph = SparseGraph.new(false)


func _on_button_pressed() -> void:
	graph.add_vertex()
	update_tree()

func update_tree() -> void:
	graph_tree.clear()
	
	var root = graph_tree.create_item()
	graph_tree.hide_root = true
	
	for node:GraphVertex in graph.nodes:
		var vertex_item = graph_tree.create_item(root)
		vertex_item.set_text(0, node.vertex_text())


func _on_graph_tree_item_selected() -> void:
	update_node_manipulation()

func update_node_manipulation() -> void:
	var selected_item = graph_tree.get_selected()
	if selected_item:
		node_label.text = selected_item.get_text(0)
