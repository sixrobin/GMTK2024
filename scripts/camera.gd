extends Node

@export var TARGET: Node = null
@export var MAX_DISTANCE: float = 50
@export var SMOOTH_SPEED: float = 1

var smooth_position := Vector2.INF

func _process(delta: float):
	if TARGET:
		smooth_position = TARGET.position + self.position
		smooth_position.x = clamp(smooth_position.x, -MAX_DISTANCE + TARGET.position.x, MAX_DISTANCE + TARGET.position.x)
		smooth_position.y = clamp(smooth_position.x, -MAX_DISTANCE + TARGET.position.y, MAX_DISTANCE + TARGET.position.y)
	
	if smooth_position != Vector2.INF:
		self.position = lerp(self.position, smooth_position, delta * SMOOTH_SPEED)
