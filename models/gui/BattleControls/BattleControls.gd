extends Control

const ObjectMenu = preload("res://models/gui/ObjectMenu/ObjectMenu.tscn");
const SkillMenu = preload("res://models/gui/SkillMenu/SkillMenu.tscn");

signal onRunSelect;
signal onAtackSelect(id_skill);
signal onObjectSelect(id_object);

func _ready():
	$Buttons/Atack.connect("pressed", self, "_on_click_button_atack");
	$Buttons/Objects.connect("pressed", self, "_on_click_button_object");
	$Buttons/Run.connect("pressed", self, "_on_click_button_run");

# Signal Functions
func _on_click_button_atack():
	var menu = SkillMenu.instance();
	menu.connect("onSkillSelected", self, "_on_skill_selected");
	add_child(menu);

func _on_click_button_object():
	var menu = ObjectMenu.instance();
	menu.connect("onItemSelect", self, "_on_object_selected");
	add_child(menu);

func _on_click_button_run():
	emit_signal("onRunSelect");
	queue_free();

# Signals Skill Menu
func _on_skill_selected(skill_id):
	emit_signal("onAtackSelect", skill_id);
	queue_free();

# Signals Object Menu
func _on_object_selected(id):
	emit_signal("onObjectSelect", id);
	queue_free();
