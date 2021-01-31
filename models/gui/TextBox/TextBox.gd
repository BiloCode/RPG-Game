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
		visible = false;
		return;
	
	$Box/CharacterName.text = character_name;
	$Box/Message.visible_characters = 0;
	$Box/Message.text = message[message_index];
	$MessageTime.wait_time = letter_delay;
	$MessageTime.start();
	
func _process(delta):
	if message.size() == 0:
		return;
	
	var key_action = Input.is_action_just_pressed("ui_accept");
	if key_action :
		if $Box/Message.visible_characters == -1:
			message_index += 1;
			if message_index == message.size():
				queue_free();
				emit_signal("onTextBoxDestroy");
				return;

			$Box/Message.visible_characters = 0;
			$Box/Message.text = message[message_index];
			$MessageTime.start();
			return;

		$Box/Message.visible_characters = -1;
		$MessageTime.stop();

func _on_CharacterTime_timeout():
	if $Box/Message.visible_characters < message[message_index].length():
		$Box/Message.visible_characters += 1;
		return;
	
	$Box/Message.visible_characters = -1;
	$MessageTime.stop();
