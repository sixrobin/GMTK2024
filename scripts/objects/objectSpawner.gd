extends Node2D
class_name ObjectSpawner

@export var amount_to_spawn: int = 1
@export var quantity: int = -1
@export var prefabs: Array[PackedScene] = []
@export var random_angle: Vector2 = Vector2.ZERO
@export var spawn_force: float = 0

@export var opening_timer: Timer
@export var opened_texture: Texture2D

var spawned_amount: int = 0
var on_click_handler: ObjectOnClickHandler
var previous_texture: Texture

func _ready() -> void:
	if opening_timer:
		opening_timer.timeout.connect(on_opening_timer_end)

func set_on_click_handler(handler: ObjectOnClickHandler):
	self.on_click_handler = handler

func spawn_object(position: Vector2, orientation: float, parent: Node2D):
	if opening_timer != null:
		previous_texture = on_click_handler.parent.sprite.texture
		if opened_texture:
			on_click_handler.parent.sprite.texture = opened_texture
		opening_timer.start()
	
	for i in amount_to_spawn:
		if quantity > 0 and spawned_amount > quantity:
			return
			
		var object : ObjectOfInterest = prefabs.pick_random().instantiate()
		parent.add_child(object)
		object.global_position = position
		
		if spawn_force > 0:
			var random: float = randf_range(random_angle.x, random_angle.y)
			var direction = Vector2.RIGHT.rotated(orientation + deg_to_rad(random))
			object.apply_impulse(direction * spawn_force)
			
		spawned_amount += 1

	var PUFF_VFX = preload("res://prefabs/VFX/puff.tscn")
	ParticlesHandler.spawn(PUFF_VFX, position)
	
func on_opening_timer_end():
	if on_click_handler.has_uses_left():
		on_click_handler.parent.sprite.texture = previous_texture
	opening_timer.stop()
