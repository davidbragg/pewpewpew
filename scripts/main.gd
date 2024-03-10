class_name Main extends Node2D

@export var player_scene : PackedScene
@export var kamikaze_scene : PackedScene
@export var floater_scene : PackedScene
@export var hunter_scene : PackedScene
@export var kamikaze_max : int = 3
@export var kamikaze_increase : int = 3
@export var player_spawn_position : Vector2 = Vector2(225, 900)
@export var lives_sprites : Array[Sprite2D] = []

var spawn_kamikaze : bool = false
var kamikaze_count : int = 0

var file_path = "user://highscore.save"

@onready var play_boundary_collider : CollisionPolygon2D = $Play_Boundary.get_child(0)
@onready var timers : Dictionary = {
	"kamikaze_spawn_limit": $KamikazeTimer,
	"kamikaze_cooldown": $KamikazeCooldownTimer,
	"floater_cooldown": $FloaterCoolDownTimer,
	"hunter_cooldown": $HunterCoolDownTimer
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GlobalState.game_state = GlobalState.TITLE
	var high_score_file = FileAccess.open(file_path, FileAccess.READ)
	if high_score_file != null:
		GlobalState.high_score = high_score_file.get_line().to_int()
		GlobalState.update_high_score()
		high_score_file.close()

func _process(_delta):
	match GlobalState.game_state:
		GlobalState.TITLE:
			set_title_screen()
		GlobalState.RESET:
			if Input.is_action_just_pressed("shoot"):
				$TitleText.visible = false
				$StartText.visible = false
				$ReadyText.visible = true
				GlobalState.game_state = GlobalState.SPAWNING
				add_player()
		GlobalState.SPAWNING:
			lives_sprites[GlobalState.player_lives - 1].visible = false
		GlobalState.PLAYSTART:
			start_gameplay()
		GlobalState.GAMEPLAY:
			pass
		GlobalState.PLAYERDEATH:
			stop_gameplay()
		GlobalState.GAMEOVER:
			reset_to_title()


##################################
### Enemy Spawn and Control ###
##################################
func _on_kamikaze_cooldown_timer_timeout():
	spawn_kamikaze = true

func _on_kamikaze_timer_timeout():
	if spawn_kamikaze:
		add_kamikaze()

func add_kamikaze():
	if GlobalState.debug:
		return

	var enemy = kamikaze_scene.instantiate()
	var kamikaze_spawn_location = $KamikazeSpawn/KamikazeSpawnLocation
	kamikaze_spawn_location.progress_ratio = randf()
	enemy.position = kamikaze_spawn_location.position
	add_child(enemy)
	kamikaze_count += 1
	if kamikaze_count >= kamikaze_max:
		spawn_kamikaze = false
		kamikaze_count = 0
		kamikaze_max += kamikaze_increase

func _on_floater_cool_down_timer_timeout():
	if GlobalState.debug:
		return

	var floater = floater_scene.instantiate()
	add_child(floater)


func _on_hunter_cool_down_timer_timeout():
	if GlobalState.debug:
		return

	var hunter = hunter_scene.instantiate()
	hunter.global_position = Vector2(randf_range(50, get_viewport_rect().size.x -50), -50)
	add_child(hunter)


####################
### Player Spawn ###
####################

func add_player():
	var player = player_scene.instantiate()
	player.position = player_spawn_position
	add_child(player)


#################################
### Gameplay State Management ###
#################################

func set_title_screen():
	$TitleText.visible = true
	$StartText.visible = true
	GlobalState.game_state = GlobalState.RESET


func stop_gameplay():
	play_boundary_collider.disabled = true
	for key in timers.keys():
		timers[key].stop()

	if GlobalState.player_lives <= 0:
		GlobalState.game_state = GlobalState.GAMEOVER
	else:
		GlobalState.game_state = GlobalState.RESET
		$StartText.visible = true


func start_gameplay():
	GlobalState.game_state = GlobalState.GAMEPLAY
	play_boundary_collider.disabled = false
	for key in timers.keys():
		timers[key].start()
	$ReadyText.visible = false


func reset_to_title():
	$GameOverText.visible = true
	var save_score = FileAccess.open(file_path, FileAccess.WRITE)
	save_score.store_line(str(GlobalState.high_score))
	save_score.close()
	await get_tree().create_timer(2.0).timeout
	GlobalState.reset_game_state()
	$GameOverText.visible = false
	for i in lives_sprites:
		i.visible = true



