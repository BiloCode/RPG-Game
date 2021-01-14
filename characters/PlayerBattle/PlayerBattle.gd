extends Node2D

var data : BattleEntity;

func _ready():
	data = BattleEntity.new("", "", 10,10,10);
