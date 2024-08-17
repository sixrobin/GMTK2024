extends Node2D

func tryCatchFood() -> void:
	var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	var result = get_world_2d().direct_space_state.intersect_point(query)
	
	for collision in result:
		if collision.has("collider"):
			var object: ObjectOfInterest = collision.collider as ObjectOfInterest
			if object != null:
				self.catchFood(object)

func catchFood(object: ObjectOfInterest) -> void:
	# start dragging the food
	pass

func destroyCursor() -> void:
	self._hideCursor()

func respawnCursor(screenPosition: Vector2) -> void:
	self._showCursor()
	self._teleportCursor(screenPosition)

func _hideCursor() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _showCursor() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _teleportCursor(screenPosition: Vector2) -> void:
	Input.warp_mouse(screenPosition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.tryCatchFood()
	pass
