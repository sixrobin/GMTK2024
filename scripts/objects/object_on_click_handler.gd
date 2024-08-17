extends Node
class_name ObjectOnClickHandler

@export var parent: Node2D = null
@export var click_needed: int = 1

@export var object_spawner: ObjectSpawner = null

var current_click_count: int = 0

func onClick():
	current_click_count += 1
	if current_click_count >= click_needed:
		self.applyClickResult()
		current_click_count = 0
		
func applyClickResult():
	if object_spawner:
		object_spawner.spawn_object(self.parent.global_position, self.parent)
