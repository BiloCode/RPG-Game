extends Reference

class_name ReduceStatistic

var stat : Statistic;

func _init(stat : Statistic):
	self.stat = stat;

func __invoke(damage : int):
	var remaining_life = stat.current_value - damage;
	if remaining_life < 0:
		remaining_life = 0;
	
	stat.current_value = remaining_life;
