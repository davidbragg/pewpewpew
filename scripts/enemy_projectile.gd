extends CharacterBody2D

const MAX_SPEED : int = 250
const ACCELERATION : int = 1000

var direction : Vector2 = Vector2.DOWN

func _process(delta):
	if GlobalState.game_state != GlobalState.GAMEPLAY:
		queue_free()

	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

	if move_and_slide():
		emit_signal("combat_collision", GlobalMessaging.combat_collision(self, get_last_slide_collision().get_collider()))


func despawn():
	queue_free()