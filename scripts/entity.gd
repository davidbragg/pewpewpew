class_name Entity extends CharacterBody2D

signal combat_collision


func register_combat_collision():
	var last_collision_object = get_last_slide_collision().get_collider()
	emit_signal("combat_collision", GlobalMessaging.combat_collision(self, last_collision_object))


func despawn():
	queue_free()