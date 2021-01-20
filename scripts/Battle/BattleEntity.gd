extends Reference

class_name BattleEntity

var name : String;
var life : Statistic;
var atack : Statistic;
var defense : Statistic;
var speed : Statistic;

func _init(name : String, life : int, atack: int, defense: int, speed: int):
	self.name = name;
	self.life = Statistic.new(life);
	self.atack = Statistic.new(atack);
	self.defense = Statistic.new(defense);
	self.speed = Statistic.new(speed);
