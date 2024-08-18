extends Node2D
class_name AttractionHandler

@export var priority: int = 10
@export var timer: Timer = null

var on_click_handler: ObjectOnClickHandler

func set_on_click_handler(handler: ObjectOnClickHandler):
	self.on_click_handler = handler
	timer.timeout.connect(on_timer_reached)

func attract():
	self.on_click_handler.parent.set_attractive(true, priority)
	timer.start()
	
func on_timer_reached():
	self.on_click_handler.parent.set_attractive(false, priority)
	timer.stop()
