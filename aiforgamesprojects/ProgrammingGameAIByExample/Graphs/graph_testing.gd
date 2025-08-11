extends Node2D


var graph: SparseGraph

func _ready() -> void:
	graph = SparseGraph.new(false)
	
	# add node to graph
	var node := GraphVertex.new(graph.next_index)
	graph.next_index +=1
	graph.add_vertex(node)
	
	
	for i in range(graph.nodes.size()):
		print(graph.nodes[i])
