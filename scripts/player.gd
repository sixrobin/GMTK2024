extends CharacterBody2D
class_name Player

@export var SMOOTH_SPEED: float = 5

var target_food: Node = null
@export var stun_timer: Timer = null
var is_stunned: bool = false

func _process(delta: float):
	if is_stunned:
		return
	if target_food == null:
		target_food = FoodManager.get_food()
	if target_food != null:
		self.position = lerp(self.position, target_food.position, delta * SMOOTH_SPEED)


func eat(food: Food):
	food.apply_eat(self)

func stun(duration: float):
	if is_stunned:
		return
	is_stunned = true
	stun_timer.start(duration)

func _on_stun_timer_timeout() -> void:
	is_stunned = false
