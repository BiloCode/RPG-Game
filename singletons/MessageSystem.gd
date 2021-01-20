extends Node

var TextBox = preload("res://models/gui/TextBox/TextBox.tscn");

func createTextBox(character_name : String, messages : Array, destiny : Node):
	var node = TextBox.instance();
	node.message = messages;
	node.character_name = character_name;
	destiny.add_child(node);
	
	return node;
