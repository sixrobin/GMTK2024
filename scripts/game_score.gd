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

func _to_string() -> String:
	var hours = total_score / 3600
	var minutes = fmod(total_score, 3600) / 60
	var seconds = fmod(total_score, 60)
	var time_string := "%02d:%02d:%02d" % [hours, minutes,seconds]
	return time_string
