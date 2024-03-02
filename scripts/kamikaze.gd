class_name Kamikaze extends Enemy

const IDLE_DIRECTION : Vector2 = Vector2(0, 1)
const IDLE_ACCELERATION : int = 2000
const IDLE_MAX_SPEED : int = 200

func _ready():
	self.rotation = Vector2(-1,0).angle()
	acceleration = 2000

func _process(delta):
	match state:
		State.SPAWNING:
			if self.global_position.y >= 100:
				state = State.TARGETING
			velocity = velocity.move_toward(IDLE_DIRECTION * IDLE_MAX_SPEED, IDLE_ACCELERATION * delta)
			move_and_slide()

		State.TARGETING:
			get_target()
			self.rotation = target.angle() - (self.rotation / 2)
			move_and_slide()
			state = State.ATTACKING

		State.ATTACKING:
			velocity = velocity.move_toward(target * max_speed, acceleration * delta)
			move_and_slide()

	if self.get_slide_collision_count() > 0:
		queue_free()

	if global_position.y > get_viewport_rect().size.y + 50 or global_position.x < -50 or global_position.x > get_viewport_rect().size.x +50:
		queue_free()
