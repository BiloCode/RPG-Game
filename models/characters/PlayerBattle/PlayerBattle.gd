extends NodeBattleEntity;

signal onSelectAction;

var BattleControls = preload("res://models/gui/BattleControls/BattleControls.tscn");

func controlsActivate(enemy):
	self.battle_target = enemy;
	
	var node = BattleControls.instance();
	node.connect("onCommandSelect", self, "_on_command_select_controls");
	get_parent().add_child(node);
	
func _on_command_select_controls(command):
	yield(get_tree().create_timer(1), "timeout");
	command_selected = command;
	
	match command:
		Types.battle_command.ATACK:
			skill_selected = "atack";
			emit_signal("onSelectAction");
		Types.battle_command.OBJECT:
			skill_selected = "object";
			emit_signal("onSelectAction");
		Types.battle_command.RUN:
			emit_signal("onSelectAction");
