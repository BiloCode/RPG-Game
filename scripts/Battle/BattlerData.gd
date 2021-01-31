extends Reference

class_name BattlerData

var name : String;
var life : Statistic;
var atack : Statistic;
var defense : Statistic;
var speed : Statistic;

func _init(name : String, life : int, atack: int, defense: int, speed: int):
	self.name = name;
	self.life = Statistic.new(life);
	self.atack = InmutableStatistic.new(atack);
	self.defense = InmutableStatistic.new(defense);
	self.speed = InmutableStatistic.new(speed);
