extends Control

const SkillButton = preload("res://models/gui/SkillMenu/SkillButton.tscn");

onready var SkillGrid = $Background/ScrollContainer/SkillGrid;
onready var UseButton = $Background/UseButton;
onready var QuitButton = $Background/QuitButton;
onready var Description = $Background/Description;

signal onCloseMenu;
signal onSkillSelected(skill_id);

var skill_id_selected : int = -1;

func _ready():
	for skill_id in PlayerStore.skills:
		var skill = GameUtility.new().GetSkillById(skill_id);
		var button = SkillButton.instance();
		
		button.skill_data = skill;
		button.connect("onClick", self, "_on_click_skill");
		SkillGrid.add_child(button);
		
	QuitButton.connect("pressed", self, "_on_click_close_button");
	UseButton.connect("pressed", self, "_on_click_use_button");
		
func _on_click_close_button():
	emit_signal("onCloseMenu");
	queue_free();

func _on_click_use_button():
	emit_signal("onSkillSelected", skill_id_selected);
	queue_free();

func _on_click_skill(button : Button):
	for button_skill in SkillGrid.get_children():
		if button_skill.skill_data.id != button.skill_data.id:
			button_skill.pressed = false;
	
	if button.pressed:
		UseButton.disabled = false;
		skill_id_selected = button.skill_data.id;
		Description.text = button.skill_data.description;
		return;
		
	Description.text = "...";
	skill_id_selected = -1;
	UseButton.disabled = true;
