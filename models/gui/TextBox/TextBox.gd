extends Control

export(float, 0.05, 0.2) var letter_delay;

var message_index = 0;
var character_name : String = "TheBilo16";
var message : Array = [
	"Hola que tal yo soy Billy",
	"Me encantaria ser tu amigo",
	"Por cierto, ¿te contaron lo que paso hace 1000 años con nuestros ancestros?"
];

func _ready():
	$CharacterName.text = character_name;
	$Message.visible_characters = 0;
	$Message.text = message[message_index];
	$MessageTime.start();
	
func _process(delta):
	var key_action = Input.is_action_just_pressed("ui_accept");
	if key_action :
		if $Message.visible_characters == -1:
			message_index += 1;
			if message_index == message.size():
				queue_free();
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
