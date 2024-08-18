class_name CreatureStatusIcon
extends Sprite2D

enum E_Status_Type
{
	NONE,
	FEAR,
	SLOW,
	ANGER,
	SLEEP,
	STUN,
	ATTRACTED,
}

@export var icon_fear: Texture2D
@export var icon_slow: Texture2D
@export var icon_anger: Texture2D
@export var icon_sleep: Texture2D
@export var icon_stun: Texture2D
@export var icon_attracted: Texture2D


func _ready():
	self.set_icon(E_Status_Type.NONE)


func on_stun(stun_type: StunResource.E_stun_mode):
	if stun_type == StunResource.E_stun_mode.STUN:
		self.set_icon(E_Status_Type.STUN)
	elif stun_type == StunResource.E_stun_mode.SLEEP:
		self.set_icon(E_Status_Type.SLEEP)
	else:
		self.set_icon(E_Status_Type.NONE)


func on_speed_boost_modified(new_boost: float):
	if new_boost > 1.0:
		self.set_icon(E_Status_Type.ANGER)
	if new_boost < 1.0:
		self.set_icon(E_Status_Type.SLOW)
	else:
		self.set_icon(E_Status_Type.NONE)


func set_icon(type: E_Status_Type):
	match type:
		E_Status_Type.FEAR:
			self.texture = self.icon_fear
		E_Status_Type.SLOW:
			self.texture = self.icon_slow
		E_Status_Type.ANGER:
			self.texture = self.icon_anger
		E_Status_Type.SLEEP:
			self.texture = self.icon_sleep
		E_Status_Type.STUN:
			self.texture = self.icon_stun
		E_Status_Type.ATTRACTED:
			self.texture = self.icon_attracted
		E_Status_Type.NONE:
			self.texture = null
		_:
			print("Status type is not handled")
			self.texture = null
