extends Node2D
class_name ObjectSpawner

@export var OBJECT_PREFABS: Array[PackedScene] = []

func spawn_object(position: Vector2, parent: Node):
	var object : Object = OBJECT_PREFABS.pick_random().instantiate()
	object.global_position = position
	parent.add_child(object)
