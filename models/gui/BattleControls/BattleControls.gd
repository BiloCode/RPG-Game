extends Control

const ObjectMenu = preload("res://models/gui/ObjectMenu/ObjectMenu.tscn");

signal onRunSelect;
signal onDefenseSelect;
signal onAtackSelect(id_skill);
signal onObjectSelect(id_object);

func _ready():
	$Buttons/Atack.connect("pressed", self, "_on_click_button_atack");
	$Buttons/Defense.connect("pressed", self, "_on_click_button_defense");
	$Buttons/Objects.connect("pressed", self, "_on_click_button_object");
	$Buttons/Run.connect("pressed", self, "_on_click_button_run");

# Signal Functions
func _on_click_button_atack():
	emit_signal("onAtackSelect", 0);
	queue_free();

func _on_click_button_object():
	var menu = ObjectMenu.instance();
	menu.connect("onCloseMenu", self, "_on_close_object_menu");
	menu.connect("onItemSelect", self, "_on_object_selected");
	add_child(menu);
	
func _on_click_button_defense():
	emit_signal("onDefenseSelect");
	queue_free();

func _on_click_button_run():
	emit_signal("onRunSelect");
	queue_free();

# Signals Object Menu
func _on_close_object_menu():
	pass

func _on_object_selected(id):
	emit_signal("onObjectSelect", id);
	queue_free();
