extends Node2D

var battle_scene = preload("res://levels/Battle/Battle.tscn");
var is_battle_process = false;

func _process(delta):
	if is_battle_process: return;
	
	var key_action = Input.is_action_just_pressed("ui_accept");
	if key_action:
		var node = battle_scene.instance();
		node.connect("onBattleEnd", self, "_on_end_battle");
		add_child(node);
		is_battle_process = true;

func _on_end_battle():
	is_battle_process = false;
