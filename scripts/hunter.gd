class_name Hunter extends Enemy

var destination_position : Vector2
var destination_clamp : int = 100
var direction : Vector2

var score : int = 100

@onready var screen_size = get_viewport_rect().size

func _ready():
    self.rotation = Vector2(-1,0).angle()
    max_speed = 250
    acceleration = 200


func _process(delta):
    if GlobalState.game_state != GlobalState.GAMEPLAY:
        queue_free()

    if state != State.EXITING:
        get_target()
        self.rotation = target.angle() - (PI / 2)

    match state:
        State.SPAWNING:
            get_destination_position()
            state = State.IDLE
        State.IDLE:
            var distance = global_position.distance_to(destination_position)
            if distance < 10 and global_position.y < 600:
                state = State.ATTACKING
            elif global_position.y >= 600:
                destination_position = Vector2(global_position.x, screen_size.y + 100)
                state = State.EXITING
        State.ATTACKING:
            add_projectile()
            get_destination_position()
            state = State.IDLE

    direction = (destination_position - global_position).normalized()
    velocity = velocity.move_toward(direction * max_speed, acceleration * delta)


    if move_and_slide():
        register_combat_collision()

    if global_position.y > get_viewport_rect().size.y + 50:
        queue_free()


func add_projectile():
    if (global_position.x > 0 or global_position.x < screen_size.x):
        var projectile = projectile_scene.instantiate()
        projectile.direction = target
        projectile.global_position = global_position
        add_sibling(projectile)


func get_destination_position():
    destination_position = Vector2(
        randi_range(destination_clamp, screen_size.x - destination_clamp),
        global_position.y + randi_range(130, 160)
    )


func despawn():
    GlobalState.add_points(score)
    queue_free()