extends Control

export(float, 0.05, 0.1) var letter_delay;

signal onTextBoxCreate;
signal onTextBoxDestroy;

var message_index = 0;
var character_name : String = "";
var message : Array = [];

func _init():
	emit_signal("onTextBoxCreate");

func _ready():
	if message.size() == 0:
		queue_free();
		return;
	
	$CharacterName.text = character_name;
	$Message.visible_characters = 0;
	$Message.text = message[message_index];
	$MessageTime.wait_time = letter_delay;
	$MessageTime.start();
	
func _process(delta):
	var key_action = Input.is_action_just_pressed("ui_accept");
	if key_action :
		if $Message.visible_characters == -1:
			message_index += 1;
			if message_index == message.size():
				queue_free();
				emit_signal("onTextBoxDestroy");
				return;

			$Message.visible_characters = 0;
			$Message.text = message[message_index];
			$MessageTime.start();
			return;

		$Message.visible_characters = -1;
		$MessageTime.stop();

func _on_CharacterTime_timeout():
	if $Message.visible_characters < message[message_index].length():
		$Message.visible_characters += 1;
		return;
	
	$Message.visible_characters = -1;
	$MessageTime.stop();
