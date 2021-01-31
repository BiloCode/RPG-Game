extends Button

var skill_data = null;

signal onClick(button);

func _ready():
	if skill_data != null:
		$Label.text = skill_data.name;

func _on_SkillButton_pressed():
	if skill_data != null:
		emit_signal("onClick", self);
