extends Node2D
class_name Food

@export var stun_duration: float = 0
@export var scalefactor: float = 1
@export var attractive: bool = true

func _ready() -> void:
	if attractive:
		FoodManager.register_food(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.eat(self)
		
func apply_eat(player: Player):
	if stun_duration != 0:
		player.stun(stun_duration)
	print("super apply eat")
	player.scale *= scalefactor
	destroy()

func destroy():
	if attractive:
		FoodManager.unregister_food(self)
	queue_free()
