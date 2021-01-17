extends Node

enum state_battle {
	LIFE_CHECK,
	CONTROLS,
	SPEED_CHECK,
	PERFORM_ACTIONS,
	TURN_END,
	WIN_BATTLE,
	LOSE_BATTLE
}

enum battle_zones {
	PLAINS = 0,
	CAVE = 1,
	DUNGEON = 2
}

enum battle_command {
	ATACK,
	OBJECT,
	RUN
}
