extends RigidBody2D
class_name Creature

signal hunger_modified(old_hunger: float, new_hunger: float)

@export var SMOOTH_SPEED: float = 5
@export var stun_timer: Timer = null
#@export var growth_meter_max: float = 100
@export var growth_stages: Array[GrowthStage]
@export var max_hunger: float = 100
@export var starting_hunger: float = 33
@export var hunger_drain: float = 2
@export var hunger_drain_interval: float = 0.5
@export var nav_agent: NavigationAgent2D = null
@export var max_sleep: float = 100
@export var sleep_increase: float = 1
@export var sleep_increase_interval: float = 0.5
@export var sleep_duration: float = 5
@export var status_icon: CreatureStatusIcon = null

@export var area: Area2D

var target_object: ObjectOfInterest = null
var is_interacting: bool = false
var is_stunned: bool = false
var speed_boost: float = 1
var current_growth_stage: int = 0
var growth_meter: float = 0
var hunger: float = 0
var hunger_drain_timer: Timer = Timer.new()
var sleep_meter: float = 0
var sleep_increase_timer: Timer = Timer.new()
var cursor_eaten: bool
var is_walking: bool = false

func _ready() -> void:
	CreatureSingleton.creature = self
	
	#Hunger initialisation
	hunger = starting_hunger
	add_child(hunger_drain_timer)
	hunger_drain_timer.timeout.connect(func(): modify_hunger(-hunger_drain))
	hunger_drain_timer.start(hunger_drain_interval)
	
	#Sleep initialisation
	add_child(sleep_increase_timer)
	sleep_increase_timer.timeout.connect(func(): increase_sleep(sleep_increase))
	sleep_increase_timer.start(sleep_increase_interval)
	
	# hook on priority change
	ObjectManager.new_highest_priority.connect(func(a, b): reset_target())
	
	#mettre la bonne size au départ
	change_creature_scale(growth_stages[current_growth_stage].scale_factor)
	
	SceneManagerSingleton.scene_load_transition.connect(on_scene_loaded)

func _process(delta: float):
	if is_stunned or is_interacting:
		return
	if target_object == null:
		try_assign_new_target()
	if target_object != null:
		self.nav_agent.target_position = target_object.global_position

func try_assign_new_target():
	if is_starving():
		target_object = ObjectManager.get_any_random()
	else:
		target_object = ObjectManager.get_best_object()
	if target_object != null:
		on_new_target_assigned()

func on_new_target_assigned():
	print("new target")
	is_walking = true
	set_anim_walk_or_idle()
	var areas = area.get_overlapping_areas()
	for x in areas:
		if x.get_parent() == target_object:
			print("is already on target!")
			self.interact(target_object)
			return

func reset_target():
	target_object = null
	is_walking = false
	set_anim_walk_or_idle()

func _physics_process(_delta):
	if self.nav_agent.is_navigation_finished() or is_stunned or is_interacting:
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = self.nav_agent.get_next_path_position()
	var force_direction: Vector2 = next_path_position - current_agent_position
	force_direction = force_direction.normalized()
	self.apply_impulse(force_direction * _delta * SMOOTH_SPEED * speed_boost * get_additional_speed_starving())
	
	#Flip sprite in the direction of movement
	if force_direction.x >0:
		$AnimatedSprite2D.flip_h = true
	elif force_direction.x <0:
		$AnimatedSprite2D.flip_h = false

# INTERACT
func interact(object: ObjectOfInterest):
	var cursor: Cursor = object.get_parent() as Cursor
	if cursor != null:
		eat_cursor(cursor)
	
	if CursorSingleton.cursor.draggedObject == object:
		CursorSingleton.cursor.tryReleaseObject()
	
	is_interacting = true
	$AnimatedSprite2D.change_anim_type($AnimatedSprite2D.E_animation_type.EATING)
	object.before_apply()
	
	if object.interaction_timer:
		add_child(object.interaction_timer)
		object.interaction_timer.timeout.connect(func(): on_interaction_end(object))
		object.interaction_timer.start()
	else:
		on_interaction_end(object)
		
func on_interaction_end(object: ObjectOfInterest):
	is_interacting = false
	$AnimatedSprite2D.change_anim_type($AnimatedSprite2D.E_animation_type.IDLE)
	object.apply()
	target_object = null
	set_anim_walk_or_idle()

# STUN
func stun(stun_resource: StunResource) -> Timer:
	return _stun(stun_resource.mode, stun_resource.duration)
	
func _stun(mode: StunResource.E_stun_mode, duration: float) -> Timer:
	if is_stunned:
		return
	is_stunned = true
	match mode:
		StunResource.E_stun_mode.STUN:
			print("stun type is stun")
		StunResource.E_stun_mode.SLEEP:
			print("stun type is sleep")
		_:
			print("stun type is not handled")
	stun_timer.start(duration)
	
	if status_icon:
		status_icon.on_stun(mode)
	
	return stun_timer

func eat_cursor(cursor: Cursor):
	cursor.destroyCursor()
	cursor_eaten = true

#Speed Boost
func speedBoost(speed_modifier: SpeedModifier):
	speed_boost = speed_modifier.modifier
	var speed_timer: Timer = Timer.new()
	add_child(speed_timer)
	speed_timer.timeout.connect(func():endSpeedBoost(speed_timer, speed_modifier))
	speed_timer.start(speed_modifier.duration)
	
	if status_icon:
		status_icon.on_speed_boost_modified(self.speed_boost)

func endSpeedBoost(timer: Timer, speed_modifier: SpeedModifier):
	speed_boost = 1
	timer.queue_free()
	
	if status_icon:
		status_icon.on_speed_boost_modified(self.speed_boost)

func _on_stun_timer_timeout() -> void:
	sleep_increase_timer.paused = false
	is_stunned = false
	set_anim_walk_or_idle()
	
	if status_icon:
		status_icon.on_stun(StunResource.E_stun_mode.NONE)

func grow(growth_value: int):
	# move in poop method
	if cursor_eaten:
		cursor_eaten = false
		CursorSingleton.cursor.respawnCursor(self.get_global_transform_with_canvas().get_origin())
	
	if current_growth_stage >= growth_stages.size() - 1:
		return
	
	growth_meter += growth_value
	
	#Si le growth meter est rempli, on passe au prochain stage et on update la scale & le sprite
	if growth_meter >= growth_stages[current_growth_stage].meter_to_next_stage:
		current_growth_stage += 1
		if current_growth_stage == 3:
			reset_target()
			is_stunned = true
			$AnimatedSprite2D.play_animation("Size3_Growing")
			$AnimatedSprite2D.loop = false
			$AnimatedSprite2D.lock_anim = true
			$AnimatedSprite2D.animation_over.connect(self.on_grow_animation_over)
		elif current_growth_stage == 6:
			SceneManagerSingleton.instance.next_scene()
		elif not SceneManagerSingleton.scene_loading:
			change_creature_scale(growth_stages[current_growth_stage].scale_factor)
			$AnimatedSprite2D.change_size(current_growth_stage+1)
	
	if growth_meter >= growth_stages[current_growth_stage].meter_to_next_stage:
		self.grow(0)

func on_grow_animation_over():
	is_stunned = false
	$AnimatedSprite2D.animation_over.disconnect(self.on_grow_animation_over)
	SceneManagerSingleton.instance.next_scene()

func modify_hunger(hunger_value):
	var old_starving = is_starving()
	var old_hunger: float = hunger
	hunger += hunger_value
	hunger = clamp(hunger,0,max_hunger)
	
	if old_hunger - hunger != 0:
		if old_starving != is_starving():
			print("starving mode changed!")
			reset_target()
		hunger_modified.emit(old_hunger,hunger)

func is_starving():
	return hunger <= 50

func get_additional_speed_starving():
	return 2 if is_starving() else 1

func increase_sleep(sleep_value):
	sleep_meter += sleep_value
	if sleep_meter >= max_sleep:
		_stun(StunResource.E_stun_mode.SLEEP, sleep_duration)
		sleep_increase_timer.paused = true
		sleep_meter = 0

func change_creature_scale(scale):
	$AnimatedSprite2D.scale.x = scale
	$AnimatedSprite2D.scale.y = scale
	$CollisionShape2D.scale.x = scale
	$CollisionShape2D.scale.y = scale

func set_anim_walk_or_idle():
	if not is_interacting and not is_stunned:
		if is_walking and current_growth_stage >= 3:
			$AnimatedSprite2D.change_anim_type($AnimatedSprite2D.E_animation_type.WALK)
		else:
			$AnimatedSprite2D.change_anim_type($AnimatedSprite2D.E_animation_type.IDLE)

func on_scene_loaded():
	$AnimatedSprite2D.loop = true
	$AnimatedSprite2D.lock_anim = false
	
	change_creature_scale(growth_stages[current_growth_stage].scale_factor)
	$AnimatedSprite2D.change_size(current_growth_stage+1)
	self.freeze = false
