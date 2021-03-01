extends Node

enum game_state {
	START,
	BATTLE,
	PAUSE
}

enum movable_direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

enum state_machine {
	IDDLE,
	MOVE
}

enum state_battle {
	LIFE_CHECK,
	NEXT_ENEMY,
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
