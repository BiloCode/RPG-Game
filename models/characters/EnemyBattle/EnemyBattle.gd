extends "res://scripts/Battle/BaseBattlerEntity.gd";

signal onDeath;

var gold;
var weapons;
var items;
var sprite = "res://assets/sprites/default.png";
var skills = [0];

func _ready():
	$Sprite.texture = load(sprite);

func targetSelection(target):
	skill_selected = GameUtility.new().GetSkillById(skills[0]);
	battle_target = target;

func perform_action():
	var is_live = playerIsLive.__invoke(data.life);
	var is_target_live = playerIsLive.__invoke(battle_target.data.life);

	if !is_live:
		$Animation.play("AnimationBattlerDeath");
	
	if !is_target_live || !is_live:
		clearBattleData();
		return;
	
	emit_signal("onBattleEntityStartAction", self);		
	animationControllerCreate();
