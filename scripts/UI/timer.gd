extends Control
class_name GameTimer

var time_elapsed: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	var minutes := time_elapsed / 60
	var seconds := fmod(time_elapsed, 60)
	var time_string := "%02d:%02d" % [minutes,seconds]
	$Label.text = time_string
