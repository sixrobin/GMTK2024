extends Node

@export var TARGET: Node = null
@export var MAX_DISTANCE: float = 50
@export var SMOOTH_SPEED: float = 1

var smooth_position := Vector2.INF

var _shake_trauma: float = 0.0
var _shake_duration: float = 0.0
var _shake_timer: float = 0.0

func _ready():
	CameraShakeBus.camera_shook.connect(self.shake)

func _process(delta: float):
	if TARGET:
		smooth_position = TARGET.position + self.position
		smooth_position.x = clamp(smooth_position.x, -MAX_DISTANCE + TARGET.position.x, MAX_DISTANCE + TARGET.position.x)
		smooth_position.y = clamp(smooth_position.x, -MAX_DISTANCE + TARGET.position.y, MAX_DISTANCE + TARGET.position.y)
	
	if smooth_position != Vector2.INF:
		self.position = lerp(self.position, smooth_position, delta * SMOOTH_SPEED)
		
	if self._shake_timer > 0.0 and self._shake_duration > 0.0:
		self.position += self.get_shake_offset()
		self._shake_timer -= delta

func shake(trauma: float, duration: float):
	self._shake_trauma = trauma * 4.0
	self._shake_duration = duration
	self._shake_timer = self._shake_duration

func get_shake_offset() -> Vector2:
	var shake_range := self._shake_trauma * 0.5
	var shake_offset := Vector2(randf_range(-shake_range, shake_range), randf_range(-shake_range, shake_range))
	shake_offset *= self._shake_timer / self._shake_duration
	return shake_offset
