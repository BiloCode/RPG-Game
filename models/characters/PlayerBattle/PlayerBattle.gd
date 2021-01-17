extends NodeBattleEntity;

signal onSelectAction;

var BattleControls = preload("res://models/gui/BattleControls/BattleControls.tscn");
var BattleControlsExpand = preload("res://models/gui/BattleControlsExpand/BattleControlsExpand.tscn")
var command_selected;

# Utilies
func controlsActivate(enemy):
	self.battle_target = enemy;
	
	var node = BattleControls.instance();
	node.connect("onCommandSelect", self, "_on_command_select_controls");
	get_parent().add_child(node);
	
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
			emit_signal("onRunBattle", self);

		clearBattleData();
		return;
		
	emit_signal("onBattleEntityStartAction", self);
	animationControllerCreate();

# Signals Functions
func _on_command_select_controls(command):
	var timer = get_tree().create_timer(0.5);
	command_selected = command;
	
	match command:
		Types.battle_command.ATACK:
			skill_selected = "atack";
			yield(timer, "timeout");
			emit_signal("onSelectAction");
		Types.battle_command.OBJECT:
			var battleControls = BattleControlsExpand.instance();
			get_parent().add_child(battleControls);
		Types.battle_command.RUN:
			skill_selected = "run";
			yield(timer, "timeout");
			emit_signal("onSelectAction");
