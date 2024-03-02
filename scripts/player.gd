extends CharacterBody2D

@export var projectile_scene : PackedScene

const MAX_SPEED : int = 300
const ACCELERATION : int = 1500
const FRICTION : int = 1000

var input : Vector2 = Vector2.ZERO
var can_fire : bool = true

signal spawn_pressed
signal player_death

@onready var fire_cooldown_timer : Timer = get_node('Fire_Cooldown')

func _physics_process(delta):
	if Input.is_action_pressed("shoot") and can_fire:
		add_projectile()
		fire_cooldown_timer.start()
		can_fire = false
	player_movement(delta)


func get_input():
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input = input.normalized()


func player_movement(delta):
	get_input()

	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()


func add_projectile():
	var projectile = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	add_sibling(projectile)


func _on_fire_cooldown_timeout():
	can_fire = true


func despawn():
	emit_signal("player_death", GlobalMessaging.player_death())
	queue_free()
