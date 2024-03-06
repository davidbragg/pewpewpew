class_name Floater extends Enemy

@export var projectile_scene : PackedScene

var target_position : Vector2
var deceleration_radius : int = 100
var min_speed : int = 10
var spawn_position : Vector2
var y_spawn_range : int = randi_range(70, 150)
var x_spawn_left : int = -50
var x_spawn_right : int = 500
var collision_count : int = 0
var score : int = 1000

func _ready():
	acceleration = 450
	max_speed = 1000
	if GlobalState.floater_spawn_side:
		global_position = Vector2(x_spawn_left, y_spawn_range)
		target_position = Vector2(randi_range(100, 200), global_position.y)
	else:
		global_position = Vector2(x_spawn_right, y_spawn_range)
		target_position = Vector2(randi_range(250, 350), global_position.y)
	GlobalState.floater_spawn_side = !GlobalState.floater_spawn_side


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
		var last_collision_object = get_last_slide_collision().get_collider()
		if last_collision_object.name == "Player":
			emit_signal("combat_collision", GlobalMessaging.combat_collision(self, last_collision_object))

		collision_count += 1

	if global_position.y > get_viewport_rect().size.y + 50:
		queue_free()

	if collision_count >= 3:
		despawn()


func add_projectiles():
	var projectiles = [projectile_scene.instantiate(), projectile_scene.instantiate(), projectile_scene.instantiate()]
	projectiles[0].direction = Vector2(7, 10).normalized()
	projectiles[1].direction = Vector2(-7, 10).normalized()
	for projectile in projectiles:
		projectile.global_position = global_position
		add_sibling(projectile)



func despawn():
	GlobalState.add_points(score)
	queue_free()


func _on_fire_cool_down_timeout():
	state = State.ATTACKING
