extends Node2D

@export var FOOD_PREFAB: PackedScene = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SpawnFood"):
		print("Spawning food!")
		self.spawn_food()

func spawn_food():
	var position = get_global_mouse_position()
	var food : Food = FOOD_PREFAB.instantiate()
	food.global_position = position
	get_parent().add_child(food)
