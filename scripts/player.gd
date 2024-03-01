extends CharacterBody2D

const max_speed = 300
const acceleration = 1000
const friction = 1000

var input = Vector2.ZERO


func _physics_process(delta):
	player_movement(delta)


func get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	input = input.normalized()


func player_movement(delta):
	get_input()

	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
