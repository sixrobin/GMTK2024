extends AnimatedSprite2D

@export var frame_rate: int = 6

var next_animation: String = ""
var loop: bool = true

func _ready():
	$FrameTimer.wait_time = 1.0 / self.frame_rate
	
func play_animation(name: String, next_name: String = ""):
	self.animation = name
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
