extends RigidBody2D
class_name ObjectOfInterest

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

@export var sprite: Sprite2D
@export var random_rotate_on_spawn: bool = false

var is_being_interacted: bool = false
var current_attractive: bool = false
var current_priority: int = 0

func _ready() -> void:
	set_attractive(attractive, priority)
	if random_rotate_on_spawn:
		self.global_rotation = deg_to_rad(randf_range(0, 360))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_being_interacted == true:
		return
	if body is Creature:
		CreatureSingleton.creature.interact(self)

func set_attractive(value: bool, specific_priority: int):
	if current_attractive == value:
		return
	current_attractive = value
	current_priority = specific_priority
	if current_attractive:
		ObjectManager.register_object(self, current_priority)
	else:
		ObjectManager.unregister_object(self, current_priority)

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
	if restored_hunger > 0:
		CreatureSingleton.creature.modify_hunger(restored_hunger)
	if speed_modifier:
		CreatureSingleton.creature.speedBoost(speed_modifier)
	on_applied()

func on_applied():
	is_being_interacted = false
	if delete_on_applied:
		destroy()
		
func destroy():
	set_attractive(false, current_priority)
	queue_free()
