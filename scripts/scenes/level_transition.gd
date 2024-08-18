class_name LevelTransition
extends Node2D

@export var _camera: Camera2D
@export var _duration: float = 1.6

@onready var _radialBlur := self._camera.get_node("RadialBlur") as Sprite2D
@onready var _whiteScreen := self._camera.get_node("WhiteScreen") as Sprite2D


func transition(from: Node2D, to: Node2D):
	self._radialBlur.visible = true
	self._whiteScreen.visible = true
	var half_duration := self._duration * 0.5
	
	var tween_in = create_tween()
	tween_in.tween_method(_tween_step_in, 0.0, 1.0, half_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	await tween_in.finished
	
	from.queue_free()
	to.visible = true
	
	# TODO: Append camera shake.
	
	var tween_out = create_tween()
	tween_out.tween_method(_tween_step_out, 1.0, 0.0, half_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween_out.tween_callback(func(): self._radialBlur.visible = false)
	tween_out.tween_callback(func(): self._whiteScreen.visible = false)
	await tween_out.finished


func _tween_step_in(value: float):
	self._camera.zoom = Vector2.ONE * remap(value, 0.0, 1.0, 1.0, 0.5)
	self._radialBlur.material.set_shader_parameter("blur_power", value * -0.1)
	self._whiteScreen.modulate.a = value


func _tween_step_out(value: float):
	self._camera.zoom = Vector2.ONE * remap(value, 1.0, 0.0, 0.5, 0.4)
	self._radialBlur.material.set_shader_parameter("blur_power", value * 0.1)
	self._whiteScreen.modulate.a = value
