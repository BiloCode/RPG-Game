extends Node2D

var AnimationController = preload("res://models/habilities/AnimationController.tscn");

var data : BattleEntity;
var battle_target;
var skill_selected : String;
var is_perform_action = false;

signal onBattleEntityEndAction;
signal onRunBattle(self_entity);
signal onBattleEntityStartAction(self_entity);

onready var playerIsLive = PlayerIsLive.new();

# Utilities
func clearBattleData():
	is_perform_action = true;
	battle_target = null;
	emit_signal("onBattleEntityEndAction");
	
func animationControllerCreate():
	var animationController = AnimationController.instance();
	add_child(animationController);
	
	animationController.call("playAnimation", self, self.battle_target);
	animationController.connect("onAnimationEnd", self, "_on_animation_controller_end_animation");
	
# Signals function
func _on_animation_controller_end_animation():
	match skill_selected:
		"atack":
			var damage = (data.atack.current_value * 4) - (battle_target.data.defense.current_value * 2);
			var reduceStatistic = ReduceStatistic.new(battle_target.data.life);
			reduceStatistic.__invoke(damage);
		"object":
			var new_life = 10;

	clearBattleData();
