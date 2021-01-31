extends Node2D

const AnimationController = preload("res://models/habilities/AnimationController.tscn");

var data : BattlerData;
var action_target;
var is_perform_action = false;
var battle_run = false;

var skill_selected : Dictionary;
var object_selected : Dictionary;

signal onBattleEntityEndAction;
signal onBattleEntityStartAction(self_entity);

onready var playerIsLive = PlayerIsLive.new();

# Utilities
func clear_battle_data():
	is_perform_action = true;
	emit_signal("onBattleEntityEndAction");
	
func animation_controller_create():
	var animationController = AnimationController.instance();
	animationController.connect("onEntityAnimationEnd", self, "_on_entity_animation_end");
	animationController.connect("onActionAnimationEnd", self, "_on_action_animation_end");
	add_child(animationController);
	
	animationController.call("playAnimation", self, self.action_target);

func normalize_data():
	# Statistic
	data.atack.normalize();
	data.defense.normalize();
	data.speed.normalize();
	
	# Battle Action
	battle_run = false;
	skill_selected = {};
	object_selected = {};
	action_target = null;
	is_perform_action = false;

# Signals function
func _on_action_animation_end():
	clear_battle_data();

func _on_entity_animation_end():
	match skill_selected.name:
		"atack":
			var causedDamage = CausedDamage.new(GameData.Random);
			var reduceStatistic = ReduceStatistic.new(action_target.data.life);
			
			var my_atack = data.atack.current_value;
			var your_defense = action_target.data.defense.current_value;
			var damage = causedDamage.__invoke(my_atack, your_defense);
			
			reduceStatistic.__invoke(damage if damage > 1 else 1);
			
		"tackle":
			var causedDamage = CausedDamage.new(GameData.Random);
			var reduceStatistic = ReduceStatistic.new(action_target.data.life);
			
			var my_atack = data.atack.current_value;
			var your_defense = action_target.data.defense.current_value;
			var damage = causedDamage.__invoke(my_atack, your_defense) * 2;
			
			reduceStatistic.__invoke(damage if damage > 1 else 1);
			
		"defense":
			data.defense.limit_break(data.defense.current_value * 2);
			
		"object":
			if object_selected.effect.type == "life":
				var increaseStatistic = IncreaseStatistic.new(data.life);
				var effectAmount = object_selected.effect.amount
				increaseStatistic.__invoke(effectAmount);
							
			PlayerStore.removeAmountItemUsed(object_selected.id, 1);
