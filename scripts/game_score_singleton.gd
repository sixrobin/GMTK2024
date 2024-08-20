extends Node

var fast_score_1: GameScore = null
var fast_score_2: GameScore = null
var fast_score_3: GameScore = null

var slow_score_1: GameScore = null
var slow_score_2: GameScore = null
var slow_score_3: GameScore = null

var current_phase_1_score: float
var current_phase_2_score: float

func register_current_score():
	var score := GameScore.new(current_phase_1_score, current_phase_2_score)
	print("NEW SCORE: phase 1 = %s, phase 2 = %s, total %s" % [score.phase_1_score, score.phase_2_score, score.total_score])
	register_score(score)
	current_phase_1_score = 0
	current_phase_2_score = 0

# :<
func register_score(score: GameScore):
	# insert the new score in the fastest scores leaderboard
	if fast_score_1 == null or score.total_score < fast_score_1.total_score:
		fast_score_3 = fast_score_2
		fast_score_2 = fast_score_1
		fast_score_1 = score
	elif fast_score_2 == null or score.total_score < fast_score_2.total_score:
		fast_score_3 = fast_score_2
		fast_score_2 = score
	elif fast_score_3 == null or score.total_score < fast_score_3.total_score:
		fast_score_3 = score
	
	# insert the new score in the slowest scores leaderboard
	if slow_score_1 == null or score.total_score > slow_score_1.total_score:
		slow_score_3 = slow_score_2
		slow_score_2 = slow_score_1
		slow_score_1 = score
	elif slow_score_2 == null or score.total_score > slow_score_2.total_score:
		slow_score_3 = slow_score_2
		slow_score_2 = score
	elif slow_score_3 == null or score.total_score > slow_score_3.total_score:
		slow_score_3 = score
