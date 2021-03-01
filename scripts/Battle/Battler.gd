extends Node2D

# Imports
const AnimationController = preload("res://models/habilities/AnimationController.tscn");

# Entity Data
var data : BattlerData;
var isDamageRecived = false;

# State Data
var states = [];
var current_turn = 0;

# Controller Battle
var reloadSprite = false;
var is_perform_action = false;
var battle_run = false;
var action_target;

# Action Battle
var skill_selected : Dictionary;
var object_selected : Dictionary;

# Signals
signal onBattleEntityEndAction;
signal onBattleEntityStartAction(self_entity);

onready var playerIsLive = PlayerIsLive.new();

# Utilities
func clear_battle_data():
	is_perform_action = true;
	emit_signal("onBattleEntityEndAction");

func is_has_state(state_id: int):
	for info in states:
		if info.state_id == state_id:
			return true;

	return false;
	
# Main
func animation_controller_create():
	var animationController = AnimationController.instance();
	animationController.connect("onEntityAnimationEnd", self, "_on_entity_animation_end");
	animationController.connect("onActionAnimationEnd", self, "_on_action_animation_end");
	add_child(animationController);
	
	animationController.call("playAnimation", self, self.action_target);

func state_checking():
	for info in states:
		var state = GameUtility.new().GetStateById(info.state_id);
		match state.name:
			"posioned":
				var reduce = ReduceStatistic.new(data.life);
				var damage = data.life.max_value * 0.1;
				reduce.__invoke(damage if damage > 1 else 1);
				isDamageRecived = true;
				
				var AnimationEntity : AnimationPlayer = get_node("Animation");
				AnimationEntity.play("AnimationBattleHit");
				
			"healing":
				var increase = IncreaseStatistic.new(data.life);
				var increase_life = data.life.max_value * 0.15;
				increase.__invoke(increase_life if increase_life > 1 else 1);
				isDamageRecived = true;
	
	current_turn += 1;
	
	var remaining_states = [];
	for info in states:
		var state = GameUtility.new().GetStateById(info.state_id);
		var turn_state_end = info.turn_start + state.turn_duration;
		if current_turn < turn_state_end or state.turn_duration == -1:
			remaining_states.append(info);
				
	states = remaining_states;	

func normalize_data():
	# Statistic
	data.atack.normalize();
	data.defense.normalize();
	data.speed.normalize();

	if playerIsLive.__invoke(data.life):
		state_checking();
	
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
			action_target.isDamageRecived = true;
			
		"tackle":
			var causedDamage = CausedDamage.new(GameData.Random);
			var reduceStatistic = ReduceStatistic.new(action_target.data.life);
			
			var my_atack = data.atack.current_value;
			var your_defense = action_target.data.defense.current_value;
			var damage = causedDamage.__invoke(my_atack, your_defense) * 2;
			
			reduceStatistic.__invoke(damage if damage > 1 else 1);
			action_target.isDamageRecived = true;
			
		"body_blow":
			var causedDamage = CausedDamage.new(GameData.Random);
			var reduceStatistic = ReduceStatistic.new(action_target.data.life);
			
			#Pendient...
			
		"defense":
			data.defense.limit_break(data.defense.current_value * 2);
			
		"health":
			var is_has_healing = is_has_state(1);
			if !is_has_healing:
				states.append({ "state_id" : 1, "turn_start" : current_turn });
			
		"posion":
			var is_has_posioned = is_has_state(0);
			if !is_has_posioned:
				action_target.states.append({ "state_id" : 0, "turn_start" : current_turn });
			
		"object":
			if object_selected.effect.type == "life":
				var increaseStatistic = IncreaseStatistic.new(data.life);
				var effectAmount = object_selected.effect.amount
				increaseStatistic.__invoke(effectAmount);
				isDamageRecived = true;
							
			PlayerStore.removeAmountItemUsed(object_selected.id, 1);
	
