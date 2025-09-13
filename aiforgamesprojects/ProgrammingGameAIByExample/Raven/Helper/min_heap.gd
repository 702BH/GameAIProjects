class_name MinHeap
extends Node

var data: Array = []

func push(value:int, priority:int):
	data.append({"val": value, "prio":priority})
	
