extends Node2D

@export var OBJECT_PREFABS: Array[PackedScene] = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SpawnObject"):
		self.spawn_object()

func spawn_object():
	var position = get_global_mouse_position()
	var object : Object = OBJECT_PREFABS.pick_random().instantiate()
	object.global_position = position
	get_parent().add_child(object)
