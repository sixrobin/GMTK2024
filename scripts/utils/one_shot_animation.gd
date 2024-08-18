extends AnimatedSprite2D

@export var frame_rate: int = 6


func _ready():
	$Timer.wait_time = 1.0 / self.frame_rate


func _on_frame_timer_timeout() -> void:
	var previous_frame = self.frame
	self.frame += 1
	if previous_frame == self.frame:
		self.queue_free()
