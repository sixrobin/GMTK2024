extends CharacterBody2D
class_name Creature

@export var SMOOTH_SPEED: float = 5
@export var stun_timer: Timer = null
#@export var growth_meter_max: float = 100
@export var growth_stages: Array[GrowthStage]
@export var nav_agent: NavigationAgent2D = null

var target_object: ObjectOfInterest = null
var is_interacting: bool = false
var is_stunned: bool = false
var speed_boost: float = 1
var current_growth_stage: int = 0
var growth_meter: float = 0

func _ready() -> void:
	CreatureSingleton.creature = self

func _process(delta: float):
	if is_stunned or is_interacting:
		return
	if target_object == null:
		target_object = ObjectManager.get_best_object()
	if target_object != null:
		self.nav_agent.target_position = target_object.global_position
		#self.position = lerp(self.position, target_object.position, delta * SMOOTH_SPEED * speed_boost)

# INTERACT
func interact(object: ObjectOfInterest):
	is_interacting = true
	object.before_apply()
	if object.interact_duration > 0:
		var interaction_timer: Timer = Timer.new()
		add_child(interaction_timer)
		interaction_timer.timeout.connect(func(): on_interaction_end(object))
		interaction_timer.timeout.connect(func(): interaction_timer.queue_free())
		interaction_timer.start(object.interact_duration)
	else:
		on_interaction_end(object)
		
func on_interaction_end(object: ObjectOfInterest):
	is_interacting = false
	object.apply()
	target_object = null

# STUN
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
	speed_boost = 1
	timer.queue_free()

func _on_stun_timer_timeout() -> void:
	is_stunned = false

func grow(growth_value: int):
	if current_growth_stage >= growth_stages.size() - 1:
		return
	
	growth_meter += growth_value
	print(growth_meter)
	
	#Si le growth meter est rempli, on passe au prochain stage et on update la scale & le sprite
	if growth_meter >= growth_stages[current_growth_stage].meter_to_next_stage:
		current_growth_stage += 1
		self.scale.x = growth_stages[current_growth_stage].scale_factor
		self.scale.y = growth_stages[current_growth_stage].scale_factor
		#updater le sprite
	
	if growth_meter >= growth_stages[current_growth_stage].meter_to_next_stage:
		self.grow(0)

func _physics_process(_delta):
	if self.nav_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = self.nav_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * SMOOTH_SPEED * speed_boost
	move_and_slide()
