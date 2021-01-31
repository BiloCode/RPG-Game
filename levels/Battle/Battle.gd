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
	
func _process(delta):
	$BattleLifeBarEnemy.call("UpdateLifeBar", enemy.data.name, enemy.data.life.current_value, enemy.data.life.max_value, false);
	$BattleLifeBarPlayer.call("UpdateLifeBar", player.data.name, player.data.life.current_value, player.data.life.max_value, true);
	
	if text_box_exists or player_controls_active or entity_is_perform_action:
		return;

	match battle_state:
		Types.state_battle.LIFE_CHECK:
			var playerIsLive = PlayerIsLive.new();
			var battleLifeCheck = BPLifeCheck.new(playerIsLive);
			battle_state = battleLifeCheck.__invoke(player, enemy);

		Types.state_battle.CONTROLS:
			player.call("create_controls", enemy);
			enemy.call("target_selection", player);
			player_controls_active = true;
			
		Types.state_battle.SPEED_CHECK:
			var speedCheck = BPSpeedCheck.new(GameData.Random);
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
			enemy.normalize_data();
			player.normalize_data();
			battle_state = Types.state_battle.LIFE_CHECK;
			
		Types.state_battle.WIN_BATTLE:
			print("win");
			#emit_signal("onBattleEnd");
			#queue_free();
			
		Types.state_battle.LOSE_BATTLE:
			print("Lose");

#Entities Init
func playerInitData(player):
	player.data = BattlerData.new(
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
	var generateEnemy = RandomEnemy.new(GameData.Random);
	var randomEnemy = generateEnemy.__invoke(battle_zone, GameData.monsters);
	
	enemy.sprite = randomEnemy.sprite;
	enemy.weapons = randomEnemy.treasures.weapons;
	enemy.gold = randomEnemy.treasures.gold;
	enemy.items = randomEnemy.treasures.items;
	enemy.data = BattlerData.new(
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
func _on_battle_entity_start_action(self_entity):
	entity_is_perform_action = true;

func _on_battle_entity_end_action():
	current_index += 1;
	entity_is_perform_action = false;

func _on_player_select_action():
	battle_state = Types.state_battle.SPEED_CHECK;
	player_controls_active = false;

func _on_entity_run_battle():
	queue_free();
