extends Control

export(Types.battle_command) var atack_button;
export(Types.battle_command) var object_button;
export(Types.battle_command) var run_button;

signal onCommandSelect(battle_command);

func _ready():
	$AtackButton.connect("pressed", self, "_on_pressed_atack_button");
	$ObjectButton.connect("pressed", self, "_on_pressed_object_button");
	$RunButton.connect("pressed", self, "_on_pressed_run_button");
	
func _on_pressed_atack_button():
	emit_signal("onCommandSelect", atack_button);
	queue_free()
	
func _on_pressed_object_button():
	emit_signal("onCommandSelect", object_button);
	queue_free()

func _on_pressed_run_button():
	emit_signal("onCommandSelect", run_button);
	queue_free()
