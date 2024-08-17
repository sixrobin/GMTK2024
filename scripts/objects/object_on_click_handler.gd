extends Node
class_name ObjectOnClickHandler

@export var parent: ObjectOfInterest = null
@export var click_needed: int = 1

@export var destroy_after_x_click: int = -1

@export var object_spawner: ObjectSpawner = null

var current_click_count: int = 0

func onClick():
	current_click_count += 1
	if current_click_count % click_needed == 0:
		self.applyClickResult()
	if destroy_after_x_click > 0 and current_click_count >= destroy_after_x_click:
		self.parent.destroy()

func applyClickResult():
	if object_spawner:
		object_spawner.spawn_object(self.parent.global_position, self.parent.rotation, self.parent.get_parent())
