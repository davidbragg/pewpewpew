class_name Hunter extends Enemy

var destination_position : Vector2
var direction : Vector2

var score : int = 100

func _ready():
    self.rotation = Vector2(-1,0).angle()
    max_speed = 100
    acceleration = 800


func _process(delta):
    if GlobalState.game_state != GlobalState.GAMEPLAY:
        queue_free()

    match state:
        State.SPAWNING:
            get_destination_position()
            state = State.IDLE
        State.IDLE:
            var distance = global_position.distance_to(destination_position)
            if distance < 10 and global_position.y < 600:
                state = State.ATTACKING
        State.ATTACKING:
            get_target()
            add_projectile()
            get_destination_position()
            state = State.IDLE

    velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

    if move_and_slide():
        register_combat_collision()

    if global_position.y > get_viewport_rect().size.y + 50:
        queue_free()


func add_projectile():
    var projectile = projectile_scene.instantiate()
    projectile.direction = target
    projectile.global_position = global_position
    add_sibling(projectile)


func get_destination_position():
    var screen_size = get_viewport_rect().size
    destination_position = Vector2(randi_range(50, screen_size.x - 50), global_position.y + randi_range(130, 160))
    direction = (destination_position - global_position).normalized()
    self.rotation = target.angle() - (PI / 2)


func despawn():
    GlobalState.add_points(score)
    queue_free()