extends Reference;

class_name Statistic

var initial_value : int;
var current_value : int;
var max_value : int;

func _init(value : int):
	self.initial_value = value;
	self.current_value = value;
	self.max_value = value;
