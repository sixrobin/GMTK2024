extends Node2D
class_name SceneManager

@export var scenes: Array[PackedScene] = []

var scene_index: int = 0
var current_scene

func _ready() -> void:
	SceneManagerSingleton.instance = self
	load_current_scene()

func next_scene():
	if scene_index >= scenes.size():
		return
	current_scene.queue_free()
	scene_index += 1
	load_current_scene()
	
func load_current_scene():
	current_scene = scenes[scene_index].instantiate()
	self.add_child(current_scene)
	current_scene.global_position = CreatureSingleton.creature.global_position
	# refresh nav ? change nav ?
