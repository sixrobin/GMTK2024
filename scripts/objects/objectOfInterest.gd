extends Node2D
class_name ObjectOfInterest

var is_being_interacted: bool = false

@export var attractive: bool = true
@export var delete_on_applied: bool = true

@export var interact_duration: float = 0

@export var stun_resource: StunResource = null

@export var scale_factor: float = 1
@export var speed_modifier: SpeedModifier = null

func _ready() -> void:
	if attractive:
		ObjectManager.register_object(self)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_being_interacted == true:
		return
	if body is Player: 
		body.interact(self)

func before_apply():
	is_being_interacted = true

func apply(player: Player):
	if stun_resource:
		player.stun(stun_resource) 
	if scale_factor != 1:
		player.scale *= scale_factor
	if speed_modifier:
		player.speedBoost(speed_modifier)
	on_applied()

func on_applied():
	is_being_interacted = false
	if attractive:
		ObjectManager.unregister_object(self)
	if delete_on_applied:
		queue_free()
