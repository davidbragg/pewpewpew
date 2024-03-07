extends Entity

const MAX_SPEED : int = 600
const ACCELERATION : int = 10000
const DIRECTION : Vector2 = Vector2.UP

func _process(delta):
	velocity = velocity.move_toward(DIRECTION * MAX_SPEED, ACCELERATION * delta)

	if move_and_slide():
		register_combat_collision()

	if global_position.y < -50:
		despawn()