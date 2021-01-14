extends Reference

class_name BattleEntity

var name : String;
var sprite : String;
var atack : Statistic;
var defense : Statistic;
var speed : Statistic;

func _init(name : String, sprite : String, atack: int, defense: int, speed: int):
	self.name = name;
	self.sprite = sprite;
	self.atack = Statistic.new(atack);
	self.defense = Statistic.new(defense);
	self.speed = Statistic.new(speed);
