extends Button

@export var ui: Control = null
@export var game_scene: PackedScene = null

func _pressed():
	ui.hide()
	var game = game_scene.instantiate()
	get_tree().root.add_child(game)
