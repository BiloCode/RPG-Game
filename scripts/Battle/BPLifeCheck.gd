extends Resource

class_name BPLifeCheck

var playerIsLive : PlayerIsLive;

func _init(playerIsLive : PlayerIsLive):
	self.playerIsLive = playerIsLive;

func __invoke(player, enemy):
	var player_live = self.playerIsLive.__invoke(player.data.life);
	var enemy_live = self.playerIsLive.__invoke(enemy.data.life);
	
	if player_live && enemy_live:
		return Types.state_battle.CONTROLS;
	elif player_live && !enemy_live:
		return Types.state_battle.WIN_BATTLE;
	else:
		return Types.state_battle.LOSE_BATTLE;
