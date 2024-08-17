extends CharacterBody2D
class_name Player

@export var SMOOTH_SPEED: float = 5
var speed_boost: float = 1
@export var stun_timer: Timer = null

var target_object: ObjectOfInterest = null
var is_stunned: bool = false

func _process(delta: float):
	if is_stunned:
		return
	if target_object == null:
		target_object = ObjectManager.get_first_object()
	if target_object != null:
		self.position = lerp(self.position, target_object.position, delta * SMOOTH_SPEED * speed_boost)

func interact(object: ObjectOfInterest):
	object.before_apply()
	if object.interact_duration >0:
		var interaction_timer: Timer = Timer.new()
		add_child(interaction_timer)
		interaction_timer.timeout.connect(func():object.apply(self))
		interaction_timer.timeout.connect(func():interaction_timer.queue_free())
		interaction_timer.start(object.interact_duration)
	else:
		object.apply(self)

func stun(stun_resource: StunResource) -> Timer:
	if is_stunned:
		return
	is_stunned = true
	match stun_resource.mode:
		StunResource.E_stun_mode.STUN:
			print("stun type is stun")
		StunResource.E_stun_mode.SLEEP:
			print("stun type is sleep")
		_:
			print("stun type is not handled")
	stun_timer.start(stun_resource.duration)
	return stun_timer

#Speed Boost
func speedBoost(speed_modifier: SpeedModifier):
	speed_boost = speed_modifier.modifier
	var speed_timer: Timer = Timer.new()
	add_child(speed_timer)
	speed_timer.timeout.connect(func():endSpeedBoost(speed_timer, speed_modifier))
	speed_timer.start(speed_modifier.duration)

func endSpeedBoost(timer: Timer, speed_modifier: SpeedModifier):
	print("end speed boost")
	speed_boost = 1
	timer.queue_free()

func _on_stun_timer_timeout() -> void:
	is_stunned = false
