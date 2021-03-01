extends "res://scripts/Battle/Battler.gd";

const BattleControls = preload("res://models/gui/BattleControls/BattleControls.tscn");

signal onRunBattle;
signal onSelectAction;
signal onPlayerDamageRecived;

func _process(delta):
	if isDamageRecived:
		emit_signal("onPlayerDamageRecived");
		isDamageRecived = false;

# Actions
func create_controls(target):
	action_target = target;
	
	var controls = BattleControls.instance();
	controls.connect("onAtackSelect", self, "_on_atack_select");
	controls.connect("onObjectSelect", self, "_on_object_select");
	controls.connect("onRunSelect", self, "_on_run_select");
	
	get_parent().add_child(controls);

func perform_action():
	var is_live = playerIsLive.__invoke(data.life);
	var is_target_live = playerIsLive.__invoke(action_target.data.life);
	if !is_target_live || !is_live:
		clear_battle_data();
		return;
	
	if battle_run:
		var speed : int = data.speed.current_value;
		var target_speed : int = action_target.data.speed.current_value;
		if speed > target_speed:
			emit_signal("onRunBattle");

		clear_battle_data();
		return;
		
	emit_signal("onBattleEntityStartAction", self);
	animation_controller_create();

# Utils
func finalize_controls_action():
	yield(get_tree().create_timer(0.8), "timeout");
	emit_signal("onSelectAction");

# Signals For Controls UI
func _on_atack_select(skill_id):
	skill_selected = GameUtility.new().GetSkillById(skill_id);
	finalize_controls_action();

func _on_object_select(object_id : int):
	skill_selected = GameUtility.new().GetSkillById(2);
	object_selected = PlayerStore.getObjectById(object_id);
	finalize_controls_action();

func _on_run_select():
	battle_run = true;
	finalize_controls_action();
