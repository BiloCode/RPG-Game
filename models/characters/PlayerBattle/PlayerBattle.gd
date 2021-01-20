extends "res://scripts/Battle/BaseBattlerEntity.gd";

const BattleControls = preload("res://models/gui/BattleControls/BattleControls.tscn");

var command_selected;

signal onRunBattle;
signal onSelectAction;

# Utilies
func finishAction():
	var timer = get_tree().create_timer(0.8);
	yield(timer, "timeout");
	emit_signal("onSelectAction");

# Actions
func createControls(target):
	battle_target = target;
	
	var controls = BattleControls.instance();
	controls.connect("onAtackSelect", self, "_on_atack_select");
	controls.connect("onObjectSelect", self, "_on_object_select");
	controls.connect("onDefenseSelect", self, "_on_defense_select");
	controls.connect("onRunSelect", self, "_on_run_select");
	get_parent().add_child(controls);

func perform_action():
	var is_live = playerIsLive.__invoke(data.life);
	var is_target_live = playerIsLive.__invoke(battle_target.data.life);
	if !is_target_live || !is_live:
		clearBattleData();
		return;
	
	if command_selected == Types.battle_command.RUN:
		var speed : int = data.speed.current_value;
		var target_speed : int = battle_target.data.speed.current_value;
		if speed > target_speed:
			emit_signal("onRunBattle");

		clearBattleData();
		return;
		
	emit_signal("onBattleEntityStartAction", self);
	animationControllerCreate();

# Signals Functions
func _on_atack_select(skill_id):
	skill_selected = GameUtility.new().GetSkillById(skill_id);
	command_selected = Types.battle_command.ATACK;
	finishAction();

func _on_object_select(object_id : int):
	skill_selected = GameUtility.new().GetSkillById(1);
	command_selected = Types.battle_command.OBJECT;
	object_selected = PlayerStore.getObjectById(object_id);
	finishAction();

func _on_defense_select():
	skill_selected = GameUtility.new().GetSkillById(2);
	command_selected = Types.battle_command.DEFENSE;
	finishAction();

func _on_run_select():
	skill_selected = GameUtility.new().GetSkillById(3);
	command_selected = Types.battle_command.RUN;
	finishAction();
