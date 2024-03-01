extends CharacterBody2D

class_name Enemy

var health : int = 500
var target : Vector2 = Vector2.ZERO
var max_speed : int = 400
var acceleration : int = 800
var state : State = State.SPAWNING

enum State {
    SPAWNING,
    TARGETING,
    ATTACKING
}

@onready var player : CharacterBody2D = get_node('/root/Game/Player')

func get_target():
    return (player.global_position - global_position).normalized()