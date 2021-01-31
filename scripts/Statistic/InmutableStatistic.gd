extends Statistic

class_name InmutableStatistic

func _init(value : int).(value):
	self.initial_value = value;
	self.current_value = value;
	self.max_value = value;

func limit_break(new_value):
	self.current_value = new_value;
	self.max_value = new_value;

func normalize():
	self.current_value = self.initial_value;
	self.max_value = self.initial_value;
