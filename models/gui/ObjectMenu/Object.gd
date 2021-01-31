extends Button

var id : int;
var item_text : String;
var item_amount : int;

signal onPressed(id);

func _ready():
	$Text.text = item_text;
	$Amount.text = "x" + str(item_amount);

func _on_Item_pressed():
	emit_signal("onPressed", id);
