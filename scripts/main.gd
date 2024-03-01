extends Node2D

@export var kamikaze_scene : PackedScene
@export var floater_scene : PackedScene
@export var hunter_scene : PackedScene

var spawn_kamikaze : bool = false
var kamikaze_count : int = 0
@export var kamikaze_max : int = 3

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
		kamikaze_max += 3



