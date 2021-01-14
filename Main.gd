extends Node2D

var battle_scene = preload("res://levels/Battle/Battle.tscn");

func _process(delta):
	var key_action = Input.is_action_just_pressed("ui_accept");

	if key_action:
		var node = battle_scene.instance();
		add_child(node);
