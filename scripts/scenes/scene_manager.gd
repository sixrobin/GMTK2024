extends Node2D
class_name SceneManager

@export var scenes: Array[PackedScene] = []
@export var game_timer: GameTimer

var scene_index: int = 0
var current_scene

signal game_over

func _ready() -> void:
	SceneManagerSingleton.instance = self
	load_current_scene()

func next_scene():
	if scene_index == 0:
		GameScoreSingleton.current_phase_1_score = game_timer.time_elapsed
	elif scene_index == 1:
		GameScoreSingleton.current_phase_2_score = game_timer.time_elapsed - GameScoreSingleton.current_phase_1_score
	
	if scene_index == scenes.size() - 1:
		SceneManagerSingleton.instance = null
		game_over.emit()
		return
	
	scene_index += 1
	load_current_scene()
	
func load_current_scene():
	var previous_scene = current_scene
	
	current_scene = scenes[scene_index].instantiate() as Node2D
	self.add_child(current_scene)
	
	if scene_index > 0:
		current_scene.visible = false
		$LevelTransition.transition(previous_scene, current_scene)
	
	current_scene.global_position = CreatureSingleton.creature.global_position
