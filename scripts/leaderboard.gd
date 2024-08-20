extends Control
class_name Leaderboard

@export var fast_score_1: RichTextLabel = null
@export var fast_score_2: RichTextLabel = null
@export var fast_score_3: RichTextLabel = null

@export var slow_score_1: RichTextLabel = null
@export var slow_score_2: RichTextLabel = null
@export var slow_score_3: RichTextLabel = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh()

func refresh():
	fast_score_1.text = "[center]%s[/center]" %(GameScoreSingleton.fast_score_1.to_string() if GameScoreSingleton.fast_score_1 != null else "--:--:--")
	fast_score_2.text = "[center]%s[/center]" %(GameScoreSingleton.fast_score_2.to_string() if GameScoreSingleton.fast_score_2 != null else "--:--:--")
	fast_score_3.text = "[center]%s[/center]" %(GameScoreSingleton.fast_score_3.to_string() if GameScoreSingleton.fast_score_3 != null else "--:--:--")
	
	slow_score_1.text = "[center]%s[/center]" %(GameScoreSingleton.slow_score_1.to_string() if GameScoreSingleton.slow_score_1 != null else "--:--:--")
	slow_score_2.text = "[center]%s[/center]" %(GameScoreSingleton.slow_score_2.to_string() if GameScoreSingleton.slow_score_2 != null else "--:--:--")
	slow_score_3.text = "[center]%s[/center]" %(GameScoreSingleton.slow_score_3.to_string() if GameScoreSingleton.slow_score_3 != null else "--:--:--")
