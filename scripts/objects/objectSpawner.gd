extends Node
class_name ObjectSpawner

@export var amount_to_spawn: int = 1
@export var quantity: int = -1
@export var prefabs: Array[PackedScene] = []

var spawned_amount: int = 0

func spawn_object(position: Vector2, parent: Node):
	for i in amount_to_spawn:
		if quantity > 0 and spawned_amount > quantity:
			return
		var object : Object = prefabs.pick_random().instantiate()
		parent.add_child(object)
		object.global_position = position
		spawned_amount += 1
