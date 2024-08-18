extends Node2D 
class_name ExplosionHandler

@export var area : Area2D
@export var force: int = 10

var on_click_handler: ObjectOnClickHandler

func set_on_click_handler(handler: ObjectOnClickHandler):
	self.on_click_handler = handler

func explode():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body is RigidBody2D and body != self.on_click_handler.parent:
			var direction = body.global_position - self.global_position
			body.apply_impulse(direction * self.force)
