extends NodeBattleEntity;

signal onDeath;

var skills = [
	"atack"
];

func targetSelection(target):
	self.command_selected = Types.battle_command.ATACK;
	self.skill_selected = skills[0];
	self.battle_target = target;
