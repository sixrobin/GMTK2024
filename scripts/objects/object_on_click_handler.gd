extends Node2D
class_name ObjectOnClickHandler

@export var parent: ObjectOfInterest = null
@export var click_needed: int = 1

@export var destroy_after_x_click: int = -1

@export var object_spawner: ObjectSpawner = null
@export var attraction_handler: AttractionHandler = null
@export var explosion_handler: ExplosionHandler = null

var current_click_count: int = 0

func _ready() -> void:
	if attraction_handler:
		attraction_handler.set_on_click_handler(self)
	if explosion_handler:
		explosion_handler.set_on_click_handler(self)

func onClick():
	current_click_count += 1
	if current_click_count % click_needed == 0:
		self.applyClickResult()
	if destroy_after_x_click > 0 and current_click_count >= destroy_after_x_click:
		self.parent.destroy()

func applyClickResult():
	if attraction_handler:
		attraction_handler.attract()
	if explosion_handler:
		explosion_handler.explode()
	if object_spawner:
		object_spawner.spawn_object(self.parent.global_position, self.parent.rotation, self.parent.get_parent())
