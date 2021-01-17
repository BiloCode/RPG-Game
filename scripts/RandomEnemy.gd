extends Node

class_name RandomEnemy

var monsterLoad : MonsterLoad;
var randomGenerator : RandomNumberGenerator;

func _init(randomGenerator : RandomNumberGenerator, monsterLoad : MonsterLoad):
	self.monsterLoad = monsterLoad;
	self.randomGenerator = randomGenerator;
	self.randomGenerator.randomize();

func __invoke(battle_zone : int):
	var monster_filter_by_zone = [];
	var monsters = monsterLoad.__invoke();
	
	for monster in monsters:
		if monster.battle_zone == battle_zone:
			monster_filter_by_zone.append(monster);
	
	var min_value = 0;
	var max_value = monster_filter_by_zone.size() - 1;
	var monster_index = self.randomGenerator.randi_range(min_value, max_value);
	
	return monster_filter_by_zone[monster_index];
