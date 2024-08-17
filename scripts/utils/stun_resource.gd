extends Resource
class_name StunResource

enum E_stun_mode {NONE,STUN,SLEEP}

@export var duration: float = 1
@export var mode: E_stun_mode = E_stun_mode.NONE

func _init(init_duration: float, init_mode: E_stun_mode) -> void:
	duration = init_duration
	mode = init_mode
