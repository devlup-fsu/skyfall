extends Control

var score = 0
var is_dead = false


func _on_score_timer_timeout():
	if not is_dead:
		score += 1
		$Label.text = "Score: %s" % score


func _on_timer_game_over():
	is_dead = true
