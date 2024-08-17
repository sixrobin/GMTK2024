extends Node2D

@onready var time: float = 0
@export var text: RichTextLabel = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	text.text = str("[center]%0.2f[/center]" % time) #format time
