extends Entity

@export var projectile_scene : PackedScene

const MAX_SPEED : int = 350
const ACCELERATION : int = 2000
const FRICTION : int = 1000

var input : Vector2 = Vector2.ZERO

var can_fire : bool = true
var has_collided : bool = false

signal player_death

@onready var fire_cooldown_timer : Timer = get_node('Fire_Cooldown')

func _ready() -> void:
	$AudioListener2D.make_current()

func _physics_process(delta):
	if GlobalState.game_state == GlobalState.SPAWNING:
		player_spawn()
		return

	if Input.is_action_pressed("shoot") and can_fire:
		add_projectile()
		fire_cooldown_timer.start()
		can_fire = false

	player_movement(delta)

	if has_collided:
		register_combat_collision()


func get_input():
	input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)


func player_movement(delta):
	get_input()

	if input.length() > 0.1:
		velocity = input.normalized() * MAX_SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	has_collided = move_and_slide()

func player_spawn():
	velocity = Vector2.UP * 100;
	move_and_slide()
	if global_position.y <= 650:
		GlobalState.game_state = GlobalState.PLAYSTART


func add_projectile():
	var projectile = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	add_sibling(projectile)
	$FireAudio.play()


func _on_fire_cooldown_timeout():
	can_fire = true


func despawn():
	Env.player_coord = position
	emit_signal("player_death", GlobalMessaging.player_death())
	queue_free()
