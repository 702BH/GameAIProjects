extends Node2D


var graph: SparseGraph

@onready var graph_tree: Tree = $Control/HBoxContainer/VBoxContainer/GraphTree
@onready var add_node_button = $Control/HBoxContainer/VBoxContainer/Button
@onready var node_label : Label = $Control/HBoxContainer/NodeManipulation/Node/Label

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
		if node == null:
			continue
		
		var vertex_item = graph_tree.create_item(root)
		vertex_item.set_text(0, node.vertex_text())
		vertex_item.set_metadata(0, {
			"type": "vertex",
			"id": node.id
		})
		for edges:GraphEdge in graph.edges[node.id]:
			var edge = graph_tree.create_item(vertex_item)
			edge.set_text(0, edges.edge_text())
			edge.set_metadata(0, {
				"type": "edge",
				"from": edges.from,
				"to": edges.to
				
			})

func _on_graph_tree_item_selected() -> void:
	update_node_manipulation()

func update_node_manipulation() -> void:
	$Control/HBoxContainer/NodeManipulation/Node/EdgeNodeOption.clear()
	var selected_item = graph_tree.get_selected()
	if selected_item:
		var meta = selected_item.get_metadata(0)
		if meta.type == "vertex":
			$Control/HBoxContainer/NodeManipulation/Node.visible=true
			$Control/HBoxContainer/NodeManipulation/Edge.visible=false
			node_label.text = selected_item.get_text(0)
			$Control/HBoxContainer/NodeManipulation/Node/RemoveNode.visible = true
			for node:GraphVertex in graph.nodes:
				if node == null or node.id == meta.id:
					continue
				$Control/HBoxContainer/NodeManipulation/Node/EdgeNodeOption.add_item(node.vertex_text(), node.id)
			$Control/HBoxContainer/NodeManipulation/Node/Label2.visible = true
			$Control/HBoxContainer/NodeManipulation/Node/EdgeNodeOption.visible=true
			if $Control/HBoxContainer/NodeManipulation/Node/EdgeNodeOption.has_selectable_items():
				$Control/HBoxContainer/NodeManipulation/Node/AddEdge.visible = true
		elif meta.type == "edge":
			$Control/HBoxContainer/NodeManipulation/Node.visible=false
			$Control/HBoxContainer/NodeManipulation/Edge.visible=true
			$Control/HBoxContainer/NodeManipulation/Edge/EdgeLabel.text = "Source Node: " + str(meta.from) + " Target Node: " + str(meta.to)
	else:
		$Control/HBoxContainer/NodeManipulation/Node/RemoveNode.visible=false
		node_label.text = "No Node Selected"
		$Control/HBoxContainer/NodeManipulation/Node/Label2.visible = false
		$Control/HBoxContainer/NodeManipulation/Node/EdgeNodeOption.visible=false
		$Control/HBoxContainer/NodeManipulation/Node/AddEdge.visible = false
		$Control/HBoxContainer/NodeManipulation/Edge.visible=false


func _on_remove_node_pressed() -> void:
	var selected_item = graph_tree.get_selected()
	if not selected_item:
		return
	var meta = selected_item.get_metadata(0)
	var node_id = meta.id
	graph.remove_vertex(node_id)
	update_tree()
	update_node_manipulation()


func _on_add_edge_pressed() -> void:
	var selected_item = graph_tree.get_selected()
	var meta = selected_item.get_metadata(0)
	var node_id = meta.id
	var target_id = $Control/HBoxContainer/NodeManipulation/Node/EdgeNodeOption.get_selected_id()
	print("Source Node: " + str(node_id))
	print("Target Node: " + str(target_id))
	graph.add_edge(node_id, target_id, 1.0)
	update_tree()
	update_node_manipulation()


func _on_remove_edge_pressed() -> void:
	var selected_item = graph_tree.get_selected()
	if not selected_item:
		return
	var meta = selected_item.get_metadata(0)
	graph.remove_edge(meta.from, meta.to)
	update_tree()
	update_node_manipulation()


func _on_dfs_pressed() -> void:
	var selected_item = graph_tree.get_selected()
	if not selected_item:
		return
	var meta = selected_item.get_metadata(0)
	var node_id = meta.id
	graph.depth_first_search(node_id)
