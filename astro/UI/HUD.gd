extends Node
extends CanvasLayer

var score := 0

func add_score(points):
    score += points
    $ScoreLabel.text = "Score: %d" % score
