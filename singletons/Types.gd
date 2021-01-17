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

enum battle_command {
	ATACK,
	OBJECT,
	RUN
}
