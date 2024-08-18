extends RigidBody2D
class_name ObjectOfInterest

@export var priority: int = 1
@export var attractive: bool = true
@export var eatable: bool = true
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
var interaction_timer: Timer

func _ready() -> void:
	if interact_duration > 0:
		interaction_timer = Timer.new()
		interaction_timer.wait_time = interact_duration
		interaction_timer.one_shot = true
	ObjectManager.register_object(self)
	set_attractive(attractive, priority)
	if random_rotate_on_spawn:
		self.global_rotation = deg_to_rad(randf_range(0, 360))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_being_interacted || !eatable:
		return
	if body is Creature:
		CreatureSingleton.creature.interact(self)

func set_attractive(value: bool, specific_priority: int):
	if current_attractive == value:
		return
	current_attractive = value
	current_priority = specific_priority
	if current_attractive:
		ObjectManager.register_object_priority(self, current_priority)
	else:
		ObjectManager.unregister_object_priority(self, current_priority)

func before_apply():
	self.linear_velocity = Vector2.ZERO
	self.angular_velocity = 0
	self.freeze = true
	
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
	queue_free()

func _notification(notification):
	if notification == NOTIFICATION_PREDELETE:
		ObjectManager.unregister_object(self)
		set_attractive(false, current_priority)
		if interaction_timer and !interaction_timer.is_stopped():
			interaction_timer.stop()
			interaction_timer.timeout.emit()
