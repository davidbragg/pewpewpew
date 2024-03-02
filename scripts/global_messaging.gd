extends Node

func player_death():
	GlobalState.game_state = GlobalState.PLAYERDEATH
	GlobalState.player_lives -= 1
	print("Player Died. Lives: " + str(GlobalState.player_lives))

func combat_collision(sender: Object, collider: Object):
	sender.despawn()
	collider.despawn()
