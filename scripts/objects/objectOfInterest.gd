extends Node2D
class_name ObjectOfInterest

@export var attractive: bool = true
@export var delete_on_applied: bool = true

@export var stun_duration: float = 0
@export var scale_factor: float = 1
@export var speed_modifier: SpeedModifier = null

func _ready() -> void:
	if attractive:
		ObjectManager.register_object(self)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interact(self)

func apply(player: Player):
	if stun_duration != 0:
		player.stun(stun_duration) 
	if scale_factor != 1:
		player.scale *= scale_factor
	if speed_modifier:
		player.speedBoost(speed_modifier)
	on_applied()

func on_applied():
	if attractive:
		ObjectManager.unregister_object(self)
	if delete_on_applied:
		queue_free()
