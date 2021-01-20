extends Resource

class_name BPSpeedCheck

var RanNumber : RandomNumberGenerator;

func _init(RanNumber : RandomNumberGenerator):
	RanNumber.randomize();
	self.RanNumber = RanNumber;
	
func __invoke(player, enemy):
	var perform_order = []
	var player_speed = player.data.speed.current_value;
	var enemy_speed = enemy.data.speed.current_value;
	
	if player_speed > enemy_speed:
		perform_order = [ player , enemy ];
	elif enemy_speed > player_speed:
		perform_order = [ enemy , player ];
	else:
		var probability = self.RanNumber.randi_range(0,1);
		if probability == 0:
			perform_order = [ enemy , player ];
		elif probability == 1:
			perform_order = [ player , enemy ];
	
	return perform_order;
