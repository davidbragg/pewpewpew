class_name Main extends Node2D

@export var player_scene : PackedScene
@export var kamikaze_scene : PackedScene
@export var floater_scene : PackedScene
@export var hunter_scene : PackedScene
@export var kamikaze_max : int = 3
@export var kamikaze_increase : int = 3
@export var player_spawn_position : Vector2 = Vector2(225, 900)

var spawn_kamikaze : bool = false
var kamikaze_count : int = 0

@onready var play_boundary_collider = $Play_Boundary.get_child(0)

func _ready():
	GlobalState.game_state = GlobalState.TITLE

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
		GlobalState.PLAYSTART:
			start_gameplay()
		GlobalState.GAMEPLAY:
			pass
		GlobalState.PLAYERDEATH:
			stop_gameplay()
		GlobalState.GAMEOVER:
			reset_to_title()

##################################
### Kamikaze Spawn and Control ###
##################################

func _on_kamikaze_cooldown_timer_timeout():
	spawn_kamikaze = true

func _on_kamikaze_timer_timeout():
	if spawn_kamikaze:
		add_kamikaze()

func add_kamikaze():
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
	$KamikazeTimer.stop()
	$KamikazeCooldownTimer.stop()

	if GlobalState.player_lives <= 0:
		GlobalState.game_state = GlobalState.GAMEOVER
	else:
		GlobalState.game_state = GlobalState.RESET
		$StartText.visible = true


func start_gameplay():
	GlobalState.game_state = GlobalState.GAMEPLAY
	play_boundary_collider.disabled = false
	$KamikazeTimer.start()
	$KamikazeCooldownTimer.start()
	$ReadyText.visible = false


func reset_to_title():
	$GameOverText.visible = true
	await get_tree().create_timer(2.0).timeout
	$GameOverText.visible = false
	GlobalState.game_state = GlobalState.TITLE
