extends Control

signal onCloseMenu;
signal onItemSelect;

const ObjectMenu = preload("res://models/gui/ObjectMenu/Object.tscn");

onready var CloseButton = $Background/CloseButton;
onready var ObjectGrid = $Background/Container/ObjectGrid;

func _ready():		
	var objects = PlayerStore.getObjects();
	for item in objects:
		var object = ObjectMenu.instance();
		object.id = item.id;
		object.item_text = item.name;
		object.item_amount = item.amount;
		object.connect("onPressed", self, '_on_select_item');
		ObjectGrid.add_child(object);
		
	CloseButton.connect("pressed", self, "_on_close_button_pressed");
	
# Signals function
func _on_select_item(id : int):
	emit_signal("onItemSelect", id);
	queue_free();

func _on_close_button_pressed():
	emit_signal("onCloseMenu");
	queue_free();
