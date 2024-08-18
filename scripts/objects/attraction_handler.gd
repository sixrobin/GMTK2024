extends Node2D
class_name AttractionHandler

@export var priority: int = 10
@export var timer: Timer = null
@export var attraction_sprite: Node2D

var on_click_handler: ObjectOnClickHandler

func set_on_click_handler(handler: ObjectOnClickHandler):
	self.on_click_handler = handler
	timer.timeout.connect(on_timer_reached)

func attract():
	if attraction_sprite:
		attraction_sprite.visible = true
	self.on_click_handler.parent.set_attractive(true, priority)
	timer.start()
	
func on_timer_reached():
	if attraction_sprite:
		attraction_sprite.visible = false
	self.on_click_handler.parent.set_attractive(false, priority)
	timer.stop()
