extends Node

var player_lives : int = 3
var score : int = 0
var high_score : int = 0
var game_state : int:
    set(value):
        game_state = value
        print("Current Game State:" + str(game_state))

enum {
    TITLE,
    RESET,
    SPAWNING,
    PLAYSTART,
    GAMEPLAY,
    PLAYERDEATH,
    GAMEOVER
}