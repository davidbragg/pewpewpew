class_name Floater extends Enemy

var target_position : Vector2
var deceleration_radius : int = 100
var y_spawn_range : int = randi_range(70, 150)
var x_spawn_left : int = -50
@onready var x_spawn_right : int = get_viewport_rect().size.x + 50
var collision_count : int = 0
var score : int = 1000

func _ready():
	acceleration = 450
	max_speed = 1000
	if randf() > 0.5:
		global_position = Vector2(x_spawn_left, y_spawn_range)
		target_position = Vector2(randi_range(100, 200), global_position.y)
	else:
		global_position = Vector2(x_spawn_right, y_spawn_range)
		target_position = Vector2(randi_range(250, 350), global_position.y)


func _process(delta):
	if GlobalState.game_state != GlobalState.GAMEPLAY:
		queue_free()

	match state:
		State.SPAWNING:
			var direction = (target_position - global_position).normalized()
			var distance = global_position.distance_to(target_position)

			if distance > deceleration_radius:
				velocity += direction * acceleration * delta
				velocity = velocity.clamp(Vector2(-max_speed, -max_speed), Vector2(max_speed, max_speed))
			elif distance > 1.5:
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
				velocity *= 0.9
			else:
				get_node('FireCoolDown').start()
				state = State.ATTACKING
		State.IDLE:
			velocity = Vector2.DOWN * 100
		State.ATTACKING:
			add_projectiles()
			velocity = Vector2.UP * 100
			state = State.IDLE

	if move_and_slide():
		register_combat_collision()

	if global_position.y > get_viewport_rect().size.y + 50:
		queue_free()


func add_projectiles():
	var projectiles = [projectile_scene.instantiate(), projectile_scene.instantiate(), projectile_scene.instantiate()]
	projectiles[0].direction = Vector2(7, 10).normalized()
	projectiles[1].direction = Vector2(-7, 10).normalized()
	for projectile in projectiles:
		projectile.global_position = global_position
		add_sibling(projectile)



func despawn():
	collision_count += 1
	if collision_count >= 4:
		GlobalState.add_points(score)
		queue_free()


func _on_fire_cool_down_timeout():
	state = State.ATTACKING
