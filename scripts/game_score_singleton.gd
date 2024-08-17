extends Node

var fast_score_1: GameScore = null
var fast_score_2: GameScore = null
var fast_score_3: GameScore = null

var slow_score_1: GameScore = null
var slow_score_2: GameScore = null
var slow_score_3: GameScore = null

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
