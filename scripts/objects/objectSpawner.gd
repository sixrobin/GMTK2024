extends Node
class_name ObjectSpawner

@export var amount_to_spawn: int = 1
@export var quantity: int = -1
@export var prefabs: Array[PackedScene] = []
@export var random_angle: Vector2 = Vector2.ZERO
@export var spawn_force: float = 0

var spawned_amount: int = 0

func spawn_object(position: Vector2, orientation: float, parent: Node2D):
	for i in amount_to_spawn:
		if quantity > 0 and spawned_amount > quantity:
			return
			
		var object : ObjectOfInterest = prefabs.pick_random().instantiate()
		parent.add_child(object)
		object.global_position = position
		
		if spawn_force > 0:
			var random: float = randf_range(random_angle.x, random_angle.y)
			var direction = Vector2.RIGHT.rotated(orientation + deg_to_rad(random))
			object.apply_impulse(direction * spawn_force)
			
		spawned_amount += 1
