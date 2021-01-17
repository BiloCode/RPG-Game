extends Node2D

var HabilityController = preload("res://models/habilities/HabilityController.tscn");

var data : BattleEntity;
var battle_target;
var command_selected;
var skill_selected : String;
var is_perform_action = false;

signal onBattleEntityStartAction;
signal onBattleEntityEndAction;
signal onRunBattle(self_entity);

onready var playerIsLive = PlayerIsLive.new();

func clearBattleData():
	is_perform_action = true;
	battle_target = null;
	emit_signal("onBattleEntityEndAction");

func perform_action():
	var is_live = playerIsLive.__invoke(data.life);
	var is_target_live = playerIsLive.__invoke(battle_target.data.life);
	if !is_target_live || !is_live:
		clearBattleData();
		return;
	
	emit_signal("onBattleEntityStartAction");
	
	if command_selected == Types.battle_command.RUN:
		var speed : int = data.speed.current_value;
		var target_speed : int = battle_target.data.speed.current_value;
		if speed > target_speed:
			emit_signal("onRunBattle", self);

		clearBattleData();
		return;
		
	var animationController = HabilityController.instance();
	animationController.connect("onAnimationEnd", self, "_on_controller_end_animation");
	add_child(animationController);
	
	animationController.call("playAnimation", self, battle_target);
	
func _on_controller_end_animation():
	match skill_selected:
		"atack":
			var damage = (data.atack.current_value * 4) - (battle_target.data.defense.current_value * 2);
			var reduceStatistic = ReduceStatistic.new(battle_target.data.life);
			reduceStatistic.__invoke(damage);
		"object":
			var new_life = 10;

	clearBattleData();
