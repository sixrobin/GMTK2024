extends CharacterBody2D
class_name Player

@export var SMOOTH_SPEED: float = 5
@export var stun_timer: Timer = null

var target_object: ObjectOfInterest = null
var is_stunned: bool = false

func _process(delta: float):
	if is_stunned:
		return
	if target_object == null:
		target_object = ObjectManager.get_first_object()
	if target_object != null:
		self.position = lerp(self.position, target_object.position, delta * SMOOTH_SPEED)

func interact(object: ObjectOfInterest):
	object.apply(self)

func stun(duration: float):
	if is_stunned:
		return
	is_stunned = true
	stun_timer.start(duration)

func _on_stun_timer_timeout() -> void:
	is_stunned = false
