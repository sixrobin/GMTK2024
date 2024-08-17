extends Node2D

var draggedObject: ObjectOfInterest = null
@export var debug_object_spawner: ObjectSpawner

func getObjectAtMousePosition() -> ObjectOfInterest:
	var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	var result = get_world_2d().direct_space_state.intersect_point(query)
	
	for collision in result:
		if collision.has("collider"):
			var object: ObjectOfInterest = collision.collider as ObjectOfInterest
			if object != null and !object.is_being_interacted:
				return object
	
	return null

func tryCatchObject() -> bool:
	var obj = self.getObjectAtMousePosition()
	if obj:
		self.catchObject(obj)
		return true
	return false

func catchObject(object: ObjectOfInterest):
	print("catch " + object.name)
	draggedObject = object

func tryReleaseObject():
	if draggedObject == null:
		return
	
	print("release " + draggedObject.name)
	draggedObject = null
	
func tryClickObject() -> bool:
	var obj = self.getObjectAtMousePosition()
	if obj:
		self.clickObject(obj)
		return true
	return false

func clickObject(object: ObjectOfInterest):
	object.on_click()

func destroyCursor():
	self._hideCursor()

func respawnCursor(screenPosition: Vector2):
	self._showCursor()
	self._teleportCursor(screenPosition)

func _hideCursor() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _showCursor() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _teleportCursor(screenPosition: Vector2) -> void:
	Input.warp_mouse(screenPosition)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("SpawnObject"):
		self.debug_object_spawner.spawn_object(get_global_mouse_position(), 0, get_parent())
	if event.is_action_pressed("ClickObject"):
		self.tryClickObject()
	if event.is_action_pressed("StartDrag"):
		self.tryCatchObject()
	if event.is_action_released("StartDrag"):
		self.tryReleaseObject()

func _process(delta: float):
	if draggedObject == null:
		return
	
	draggedObject.global_position = get_global_mouse_position()
