extends Node


func combat_collision(sender: Object, collider: Object):
	sender.despawn()
	collider.despawn()


func player_death():
	GlobalState.game_state = GlobalState.PLAYERDEATH
	GlobalState.player_lives -= 1
