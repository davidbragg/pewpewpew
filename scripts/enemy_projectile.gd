extends Entity

const MAX_SPEED : int = 250
const ACCELERATION : int = 1000

var direction : Vector2 = Vector2.DOWN

func _process(delta):
	if GlobalState.game_state != GlobalState.GAMEPLAY:
		queue_free()

	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

	if move_and_slide():
		register_combat_collision()

	if global_position.y > get_viewport_rect().size.y + 50:
		queue_free()