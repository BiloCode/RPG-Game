extends Node2D;

var PlayerBattle = preload("res://models/characters/PlayerBattle/PlayerBattle.tscn");
var EnemyBattle = preload("res://models/characters/EnemyBattle/EnemyBattle.tscn");
var TextBox = preload("res://models/gui/TextBox/TextBox.tscn");

var player;
var enemy;

var battle_state;
var entity_list = [];
var current_index = 0;
var text_box_exists = false;
var player_controls_active = false;
var entity_is_perform_action = false;
var battle_zone = Types.battle_zones.PLAINS;

signal onBattleEnd;

func _ready():
	player = PlayerBattle.instance();
	enemy = EnemyBattle.instance();
	enemyInitData(enemy);
	playerInitData(player);
	add_child(player);
	add_child(enemy);
	
	battle_state = Types.state_battle.LIFE_CHECK;
	player.transform = $PlayerPosition.transform;
	enemy.transform = $EnemyPosition.transform;
	
	$BattleLifeBarEnemy/LifePoints.text = str(enemy.data.life.current_value) + " / " + str(enemy.data.life.max_value);
	$BattleLifeBarPlayer/LifePoints.text = str(player.data.life.current_value) + " / " + str(player.data.life.max_value);

func _process(delta):
	if text_box_exists or player_controls_active or entity_is_perform_action:
		return;
	
	match battle_state:
		Types.state_battle.LIFE_CHECK:
			var playerIsLive = PlayerIsLive.new();
			var battleLifeCheck = BPLifeCheck.new(playerIsLive);
			battle_state = battleLifeCheck.__invoke(player, enemy);

		Types.state_battle.CONTROLS:
			player.call("createControls", enemy);
			enemy.call("targetSelection", player);
			player_controls_active = true;
			
		Types.state_battle.SPEED_CHECK:
			var ranNumber = RandomNumberGenerator.new();
			var speedCheck = BPSpeedCheck.new(ranNumber);
			entity_list = speedCheck.__invoke(player, enemy);
			battle_state = Types.state_battle.PERFORM_ACTIONS;
			
		Types.state_battle.PERFORM_ACTIONS:
			var performActions = BPPerformActions.new();
			var is_finish = performActions.__invoke(entity_list, current_index);
			if is_finish:
				battle_state = Types.state_battle.TURN_END;
				
		Types.state_battle.TURN_END:
			entity_list = [];
			current_index = 0;
			player.is_perform_action = false;
			enemy.is_perform_action = false;
			battle_state = Types.state_battle.LIFE_CHECK;
			
		Types.state_battle.WIN_BATTLE:
			var text_box = textBoxCreate([
				"Has ganado el combate",
				"Has ganado " + str(enemy.gold) + " de oro"
			]);
			
			yield(text_box, "onTextBoxDestroy");
			emit_signal("onBattleEnd");
			queue_free();
			
		Types.state_battle.LOSE_BATTLE:
			print("Lose");

#Entities Init
func playerInitData(player):
	player.data = BattleEntity.new(
		PlayerStore.player_name, 
		PlayerStore.stats.life,
		PlayerStore.stats.atack,
		PlayerStore.stats.defense,
		PlayerStore.stats.speed
	);
	
	player.connect("onBattleEntityStartAction", self, "_on_battle_entity_start_action");
	player.connect("onBattleEntityEndAction", self, "_on_battle_entity_end_action");
	player.connect("onSelectAction", self, "_on_player_select_action");
	player.connect("onRunBattle", self, "_on_entity_run_battle");

func enemyInitData(enemy):
	var randomNumber = RandomNumberGenerator.new();
	var generateEnemy = RandomEnemy.new(randomNumber);
	var randomEnemy = generateEnemy.__invoke(battle_zone, GameData.monsters);
	
	enemy.sprite = randomEnemy.sprite;
	enemy.weapons = randomEnemy.treasures.weapons;
	enemy.gold = randomEnemy.treasures.gold;
	enemy.items = randomEnemy.treasures.items;
	enemy.data = BattleEntity.new(
		randomEnemy.name,
		randomEnemy.stats.life,
		randomEnemy.stats.atack,
		randomEnemy.stats.defense,
		randomEnemy.stats.speed
	);
	
	enemy.connect("onBattleEntityStartAction", self, "_on_battle_entity_start_action");
	enemy.connect("onBattleEntityEndAction", self, "_on_battle_entity_end_action");

#Utils
func textBoxCreate(message : Array):
	var node_message = MessageSystem.createTextBox("", message, self);
	text_box_exists = true;
	node_message.connect("onTextBoxDestroy", self, "_on_textbox_destroy");
	
	return node_message;

#Signals Functions
func _on_textbox_destroy():
	text_box_exists = false;

func _on_battle_entity_start_action(self_entity):
	entity_is_perform_action = true;
	var skill_name = "";
	
	match(self_entity.skill_selected.name):
		"atack":
			skill_name = "ataque";
		"object":
			skill_name = self_entity.object_selected.name;
		"defense":
			skill_name = "defensa";
	
	var text_box = textBoxCreate([ 
		 self_entity.data.name + " ha usado " + skill_name
	]);

func _on_battle_entity_end_action():
	current_index += 1;
	entity_is_perform_action = false;

func _on_player_select_action():
	battle_state = Types.state_battle.SPEED_CHECK;
	player_controls_active = false;

func _on_entity_run_battle():
	var text_box = textBoxCreate([ player.data.name + " ha escapado del combate." ]);
	yield(text_box, "onTextBoxDestroy");
	emit_signal("onBattleEnd");
	queue_free();
