extends Node2D
class_name Food

func _ready() -> void:
	FoodManager.register_food(self)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.eat(self)
		
func apply_eat(player: Player):
	print("super apply eat")
	player.scale *= 1.1
	destroy()

func destroy():
	FoodManager.unregister_food(self)
	queue_free()
