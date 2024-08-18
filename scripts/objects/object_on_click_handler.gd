extends Node2D
class_name ObjectOnClickHandler

@export var parent: ObjectOfInterest = null
@export var click_needed: int = 1
@export var max_uses: int = -1
@export var cooldown: Timer = null

@export var destroy_after_x_click: int = -1

@export var object_spawner: ObjectSpawner = null
@export var attraction_handler: AttractionHandler = null
@export var explosion_handler: ExplosionHandler = null

var current_click_count: int = 0
var is_in_cooldown: bool = false

func _ready() -> void:
	if attraction_handler:
		attraction_handler.set_on_click_handler(self)
	if explosion_handler:
		explosion_handler.set_on_click_handler(self)
	if object_spawner:
		object_spawner.set_on_click_handler(self)
	if cooldown:
		cooldown.timeout.connect(on_cooldown_end)

func onClick():
	if is_in_cooldown:
		return
	if !has_uses_left():
		return
	current_click_count += 1
	if current_click_count % click_needed == 0:
		self.applyClickResult()
	if destroy_after_x_click > 0 and current_click_count >= destroy_after_x_click:
		self.parent.destroy()
		return
	if cooldown != null:
		is_in_cooldown = true
		cooldown.start()

func on_cooldown_end():
	is_in_cooldown = false
	cooldown.stop()

func applyClickResult():
	if attraction_handler:
		attraction_handler.attract()
	if explosion_handler:
		explosion_handler.explode()
	if object_spawner:
		object_spawner.spawn_object(self.global_position, self.global_rotation, SceneManagerSingleton.instance.current_scene)

func has_uses_left() -> bool:
	return max_uses <= 0 or current_click_count < max_uses
