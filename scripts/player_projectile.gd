extends CharacterBody2D

const MAX_SPEED : int = 600
const ACCELERATION : int = 10000

var collision_data : bool


func _process(delta):
	if get_slide_collision_count() > 0:
		queue_free()

	var direction : Vector2 = Vector2.UP
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

	move_and_slide()

	if global_position.y < -50:
		queue_free()

func despawn():
	queue_free()