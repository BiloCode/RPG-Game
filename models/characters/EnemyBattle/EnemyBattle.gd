extends "res://scripts/Battle/Battler.gd";

signal onDeath;

var gold;
var weapons;
var items;
var sprite = "res://assets/sprites/default.png";
var skills = [0];

func _ready():
	$Sprite.texture = load(sprite);

func target_selection(target):
	skill_selected = GameUtility.new().GetSkillById(skills[0]);
	action_target = target;

func perform_action():
	var is_live = playerIsLive.__invoke(data.life);
	var is_target_live = playerIsLive.__invoke(action_target.data.life);

	emit_signal("onBattleEntityStartAction", self);	

	if !is_live:
		$Animation.play("AnimationBattlerDeath");
		yield($Animation, "animation_finished");
		clear_battle_data();
		return;
	
	if !is_target_live || !is_live:
		clear_battle_data();
		return;
	
	animation_controller_create();
