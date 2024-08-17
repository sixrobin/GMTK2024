class_name LevelTransition
extends Node2D

@export var _camera: Camera2D

@onready var _radialBlur := self._camera.get_node("RadialBlur") as Sprite2D


func _ready():
	await get_tree().create_timer(1.0).timeout
	self.transition(null, null)


func transition(from: Node2D, to: Node2D):
	self._radialBlur.visible = true
	
	var tween = create_tween()
	tween.tween_method(_tween_step_in, 0.0, 1.0, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	# TODO: Level transition.
	# TODO: Append camera shake.
	tween.tween_method(_tween_step_out, 1.0, 0.0, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): self._radialBlur.visible = false)


func _tween_step_in(value: float):
	self._radialBlur.material.set_shader_parameter("blur_power", value * -0.1)
	# TODO: Add white screen.


func _tween_step_out(value: float):
	self._radialBlur.material.set_shader_parameter("blur_power", value * 0.1)
	# TODO: Add white screen.
