class_name Kamikaze extends Enemy

const IDLE_DIRECTION : Vector2 = Vector2(0, 1)
const IDLE_ACCELERATION : int = 2000
const IDLE_MAX_SPEED : int = 200

var score : int = 100

func _ready():
	self.rotation = Vector2(-1,0).angle()
	acceleration = 2000


func _process(delta):
	if GlobalState.game_state != GlobalState.GAMEPLAY:
		queue_free()

	match state:
		State.SPAWNING:
			if self.global_position.y >= 100:
				state = State.TARGETING
			velocity = velocity.move_toward(IDLE_DIRECTION * IDLE_MAX_SPEED, IDLE_ACCELERATION * delta)

		State.TARGETING:
			get_target()
			self.rotation = target.angle() - (self.rotation / 2)
			state = State.ATTACKING

		State.ATTACKING:
			velocity = velocity.move_toward(target * max_speed, acceleration * delta)

	if move_and_slide():
		register_combat_collision()

	if global_position.y > get_viewport_rect().size.y + 50 or global_position.x < -50 or global_position.x > get_viewport_rect().size.x +50:
		queue_free()


func despawn():
	GlobalState.add_points(score)
	queue_free()