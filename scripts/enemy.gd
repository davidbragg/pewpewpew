class_name Enemy extends Entity

@export var projectile_scene : PackedScene

var health : int = 500
var target : Vector2 = Vector2.ZERO
var max_speed : int = 400
var acceleration : int = 800
var state : State = State.SPAWNING

enum State {
	SPAWNING,
	IDLE,
	TARGETING,
	ATTACKING,
	DEAD,
	EXITING
}

@onready var player : CharacterBody2D = get_node('/root/Game/Player')


func get_target():
	if player != null:
		target = (player.global_position - self.global_position).normalized()
