class_name Enemy extends Entity

var health : int = 500
var target : Vector2 = Vector2.ZERO
var max_speed : int = 400
var acceleration : int = 800
var state : State = State.SPAWNING

enum State {
    SPAWNING,
    IDLE,
    TARGETING,
    ATTACKING
}

@onready var player : CharacterBody2D = get_node('/root/Game/Player')


func get_target():
    target = (player.global_position - self.global_position).normalized()
