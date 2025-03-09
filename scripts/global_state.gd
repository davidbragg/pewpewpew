extends Node

var player_lives : int = 3
var score : int = 0 :
	set(value):
		score = value
		player_score_label.text = str(score)
		if score > high_score:
			high_score = score
			update_high_score()
var high_score : int = 0
var game_state : int

enum {
	TITLE,
	RESET,
	SPAWNING,
	PLAYSTART,
	GAMEPLAY,
	PLAYERDEATH,
	GAMEOVER
}

@onready var player_score_label = get_node('/root/Game/UIRect/PlayerScoreValue')
@onready var high_score_label = get_node('/root/Game/UIRect/HighScoreValue')

func add_points(points : int):
	score += points

func reset_game_state():
	player_lives = 3
	score = 0
	game_state = TITLE

func update_high_score():
	high_score_label.text = str(high_score)
