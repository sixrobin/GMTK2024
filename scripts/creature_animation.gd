class_name CreatureAnimation
extends AnimatedSprite2D

signal animation_over

@export var frame_rate: int = 6

var next_animation: String = ""
var loop: bool = true
var lock_anim: bool = false

var size: int = 1
enum E_animation_type {IDLE, HUNGRY, EATING, WALK}
var animation_type: E_animation_type = E_animation_type.IDLE

func _ready():
	$FrameTimer.wait_time = 1.0 / self.frame_rate
	
func play_animation(name: String, next_name: String = ""):
	self.animation = name
	self.frame = 0
	self.set_next_animation(next_name)
	
func set_next_animation(name: String):
	self.next_animation = name

func _on_frame_timer_timeout() -> void:
	var previous_frame = self.frame
	self.frame += 1
	
	if previous_frame == self.frame:
		if not self.next_animation.is_empty():
			play_animation(self.next_animation)
			self.next_animation = ""
		
		if self.loop:
			self.frame = 0
		else:
			self.animation_over.emit()

#Gestion de l'anim en fx de la size et de son "activité"
func change_size(new_size: int):
	size = min(new_size, 4) #ici 4 = numéro de la "dernière" anim (actuellement, size4)
	update_anim()

func change_anim_type(new_type: E_animation_type):
	animation_type = new_type
	update_anim()

func update_anim():
	if self.lock_anim:
		return
		
	match animation_type:
		E_animation_type.IDLE:
			self.play_animation("Size%s_Idle" % [size])
		E_animation_type.HUNGRY:
			self.play_animation("Size%s_Hungry" % [size])
		E_animation_type.EATING:
			self.play_animation("Size%s_Eating" % [size])
		E_animation_type.WALK:
			self.play_animation("Size%s_Walk" % [size])
