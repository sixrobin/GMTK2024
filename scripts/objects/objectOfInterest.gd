extends RigidBody2D
class_name ObjectOfInterest

var is_being_interacted: bool = false

@export var priority: int = 1
@export var attractive: bool = true
@export var delete_on_applied: bool = true

@export var interact_duration: float = 0

@export var stun_resource: StunResource = null

@export var growth_value: float = 0
@export var restored_hunger: float = 0
@export var speed_modifier: SpeedModifier = null

#ON CLICK
@export var on_click_handler : ObjectOnClickHandler

func _ready() -> void:
	if attractive:
		ObjectManager.register_object(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_being_interacted == true:
		return
	if body is Creature:
		CreatureSingleton.creature.interact(self)

func before_apply():
	is_being_interacted = true

func on_click():
	if self.on_click_handler != null:
		self.on_click_handler.onClick()

func apply():
	if stun_resource:
		CreatureSingleton.creature.stun(stun_resource)
	if growth_value > 0:
		CreatureSingleton.creature.grow(growth_value)
	if restored_hunger >0:
		CreatureSingleton.creature.modify_hunger(restored_hunger)
	if speed_modifier:
		CreatureSingleton.creature.speedBoost(speed_modifier)
	on_applied()

func on_applied():
	is_being_interacted = false
	if attractive:
		ObjectManager.unregister_object(self)
	if delete_on_applied:
		destroy()
		
func destroy():
	ObjectManager.unregister_object(self)
	queue_free()
