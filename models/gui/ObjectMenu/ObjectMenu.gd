extends Control

signal onCloseMenu;
signal onItemSelect;

const ItemMenu = preload("res://models/gui/ObjectMenu/Item.tscn");

func _ready():
	$Background/CloseButton.connect("pressed", self, "_on_close_button_pressed");
	
	for child in $Background/Container/ItemsGrid.get_children():
		child.queue_free();
			
	var objects = PlayerStore.getObjects();
	for item in objects:
		var node_item = ItemMenu.instance();
		node_item.id = item.id;
		node_item.item_text = item.name;
		node_item.item_amount = item.amount;
		node_item.connect("onPressed", self, '_on_select_item');
		$Background/Container/ItemsGrid.add_child(node_item);
	
# Signals function
func _on_select_item(id : int):
	emit_signal("onItemSelect", id);
	queue_free();

func _on_close_button_pressed():
	emit_signal("onCloseMenu");
	queue_free();
