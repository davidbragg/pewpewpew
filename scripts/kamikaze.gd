class_name Kamikaze extends Enemy

const IDLE_DIRECTION : Vector2 = Vector2(0, 1)
const IDLE_ACCELERATION : int = 2000
const IDLE_MAX_SPEED : int = 200

var score : int = 100
var audio_complete: bool = false
var particles_complete: bool = false

func _ready():
	self.rotation = Vector2(-1,0).angle()
	acceleration = 2000


func _process(delta):
	if GlobalState.game_state != GlobalState.GAMEPLAY:
		queue_free()

	match state:
		State.DEAD:
			move_and_slide()
			if audio_complete && particles_complete:
				queue_free()
			return
		State.SPAWNING:
			if self.global_position.y >= 100:
				state = State.TARGETING
			velocity = velocity.move_toward(IDLE_DIRECTION * IDLE_MAX_SPEED, IDLE_ACCELERATION * delta)

		State.TARGETING:
			get_target()
			self.rotation = target.angle() - (self.rotation / 2)
			state = State.ATTACKING
			$EngineAudio.play()

		State.ATTACKING:
			velocity = velocity.move_toward(target * max_speed, acceleration * delta)

	if move_and_slide():
		register_combat_collision()

	if global_position.y > get_viewport_rect().size.y + 50 or global_position.x < -50 or global_position.x > get_viewport_rect().size.x +50:
		queue_free()


func despawn():
	GlobalState.add_points(score)
	state = State.DEAD
	$Sprite2D.visible = false
	$CollisionPolygon2D.disabled = true
	$EngineAudio.stop()
	$DeathAudio.play()
	$ExplosionParticles.emitting = true


func _on_death_audio_finished() -> void:
	audio_complete = true

func _on_explosion_particles_finished() -> void:
	particles_complete = true
