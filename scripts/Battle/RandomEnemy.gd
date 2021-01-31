extends Node

class_name RandomEnemy

var randomGenerator : RandomNumberGenerator;

func _init(randomGenerator : RandomNumberGenerator):
	self.randomGenerator = randomGenerator;

func __invoke(battle_zone : int, monsters : Array):
	var monster_filter_by_zone = [];
	for monster in monsters:
		if monster.battle_zone == battle_zone:
			monster_filter_by_zone.append(monster);
	
	var min_value = 0;
	var max_value = monster_filter_by_zone.size() - 1;
	var monster_index = self.randomGenerator.randi_range(min_value, max_value);
	
	return monster_filter_by_zone[monster_index];
