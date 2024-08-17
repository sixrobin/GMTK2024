extends Food

func apply_eat(player: Player):
	player.scale *= 0.9
	destroy()
