class_name GameScore

var phase_1_score: float
var phase_2_score: float
var phase_3_score: float
var total_score: float

func _init(score_1: float, score_2: float, score_3: float) -> void:
	phase_1_score = score_1
	phase_2_score = score_2
	phase_3_score = score_3
	total_score = score_1 + score_2 + score_3
