extends Enemy

class_name Kamikaze

func _process(delta):
	match state:
		State.SPAWNING:
			state = State.TARGETING
		State.TARGETING:
			target = get_target()
			state = State.ATTACKING
		State.ATTACKING:
			velocity = velocity.move_toward(target * max_speed, acceleration * delta)
			move_and_slide()

	if global_position.y > get_viewport_rect().size.y + 50:
		queue_free()



