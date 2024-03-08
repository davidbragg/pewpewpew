extends Node

func combat_collision(sender: Object, collider: Object):
	if collider.name == "Play_Boundary":
		return
	sender.despawn()
	collider.despawn()


func player_death():
	GlobalState.game_state = GlobalState.PLAYERDEATH
	GlobalState.player_lives -= 1
