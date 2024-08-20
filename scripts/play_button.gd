extends Button

@export var ui: Control = null
@export var leaderboard: Leaderboard = null
@export var game_scene: PackedScene = null
var game

func _pressed():
	ui.hide()
	game = game_scene.instantiate()
	get_tree().root.add_child(game)
	SceneManagerSingleton.instance.game_over.connect(on_game_end)

func on_game_end():
	GameScoreSingleton.register_current_score()
	leaderboard.refresh()
	game.queue_free()
	ui.show()
