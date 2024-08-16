extends CharacterBody2D
class_name Player

@export var SMOOTH_SPEED: float = 5

var target_food: Node = null

func _process(delta: float):
	if target_food == null:
		target_food = FoodManager.get_food()
	if target_food != null:
		self.position = lerp(self.position, target_food.position, delta * SMOOTH_SPEED)


func eat(food: Food):
	food.apply_eat(self)
