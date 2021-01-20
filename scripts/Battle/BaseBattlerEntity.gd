extends Node2D

var AnimationController = preload("res://models/habilities/AnimationController.tscn");

var data : BattleEntity;
var battle_target;
var is_perform_action = false;

var skill_selected : Dictionary;
var object_selected : Dictionary;

signal onBattleEntityEndAction;
signal onBattleEntityStartAction(self_entity);

onready var playerIsLive = PlayerIsLive.new();

# Utilities
func clearBattleData():
	is_perform_action = true;
	battle_target = null;
	object_selected = {};
	emit_signal("onBattleEntityEndAction");
	
func animationControllerCreate():
	var animationController = AnimationController.instance();
	add_child(animationController);
	
	animationController.call("playAnimation", self, self.battle_target);
	animationController.connect("onAnimationEnd", self, "_on_animation_controller_end_animation");
	
# Signals function
func _on_animation_controller_end_animation():
	match skill_selected.name:
		"atack":
			var damage = (data.atack.current_value * 4) - (battle_target.data.defense.current_value * 2);
			var reduceStatistic = ReduceStatistic.new(battle_target.data.life);
			reduceStatistic.__invoke(damage);
		
		"defense":
			pass;
			
		"object":
			if object_selected.effect.type == "life":
				var increaseStatistic = IncreaseStatistic.new(data.life);
				increaseStatistic.__invoke(object_selected.effect.amount);
			
			var object_store = PlayerStore.getObjectById(object_selected.id);
			object_store.amount -= 1;

	clearBattleData();
