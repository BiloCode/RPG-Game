extends Reference

class_name IncreaseStatistic

var stat : Statistic;

func _init(stat : Statistic):
	self.stat = stat;

func __invoke(damage : int):
	var remaining_stat = stat.current_value + damage;
	if remaining_stat > stat.max_value:
		remaining_stat = stat.max_value;
	
	stat.current_value = remaining_stat;
