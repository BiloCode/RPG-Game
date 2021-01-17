extends NodeBattleEntity;

signal onDeath;

var gold;
var weapons;
var death_exp;
var items;
var sprite;
var skills = [
	"atack"
];

func _ready():
	var new_sprite = ImageTexture.new();
	new_sprite.load(sprite);
	$Sprite.texture = new_sprite;

func targetSelection(target):
	self.skill_selected = skills[0];
	self.battle_target = target;

func perform_action():
	var is_live = playerIsLive.__invoke(data.life);
	var is_target_live = playerIsLive.__invoke(battle_target.data.life);
	if !is_target_live || !is_live:
		clearBattleData();
		return;
	
	emit_signal("onBattleEntityStartAction", self);		
	animationControllerCreate();
