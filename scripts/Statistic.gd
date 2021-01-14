extends Reference;

class_name Statistic

var current_value : int;
var max_value : int;

func _init(value : int):
	self.current_value = value;
	self.max_value = value;
